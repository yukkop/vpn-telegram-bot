import 'dart:convert';

import 'package:http/http.dart';
import 'package:vpn_telegram_bot/constants.dart';
import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/loger.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../configurations.dart';
import '../../variables.dart';
import 'pay.const.dart';

Future<Response> iokassaReques(
    int userId, int messageId, int price, int days) async {
  var response =
      await post(Uri.https('api.yookassa.ru', "/v3/payments"), headers: {
    'Idempotence-Key': uuid.v1().toString(),
    'Content-Type': 'application/json',
    'Authorization':
        'Basic ${base64.encode(utf8.encode(Configurations.iokassaToken))}'
  }, body: '''{
          "amount": {
            "value": "$price",
            "currency": "RUB"
          },
          "capture": true,
          "confirmation": {
            "type": "redirect",
            "return_url": "${Configurations.botUrl}"
          },
          "description": "$userId;$messageId;$price;$days"
        }''');

  if (response.statusCode != 200) {
    Loger.log(response.body);
  }

  return response;
}

final payFor1Day = Page(
  name: 'Страница оплаты на 1 день',
  text: Text.function((pageMessage, user) async {
    var message = dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}choice', LayoutEnum.ru);

    return Page.stringf(message, [textForDay, rubForDay.toString()]);
  }),
  renderMethod: Page.edit,
);

final payFor1Week = Page(
  name: 'Страница оплаты на 1 неделя',
  text: Text.function((pageMessage, user) async {
    var message = dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}choice', LayoutEnum.ru);

    return Page.stringf(message, [textForWeek, rubForWeek.toString()]);
  }),
  renderMethod: Page.edit,
);

final payFor1Month = Page(
  name: 'Страница оплаты на 1 месяц',
  text: Text.function((pageMessage, user) async {
    var message = dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}choice', LayoutEnum.ru);

    return Page.stringf(message, [textForMonth, rubForMonth.toString()]);
  }),
  renderMethod: Page.edit,
);

late final payFor1Year = Page(
  name: 'Страница оплаты на 1 год',
  text: Text.function((pageMessage, user) async {
    var message = dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}choice', LayoutEnum.ru);

    return Page.stringf(message, [textForYear, rubForYear.toString()]);
  }),
  renderMethod: Page.edit,
);

void payKeyboard() {
  payFor1Day.changeKeyboard(Keyboard.function((pageMessage, user) async {
    var responseBody = jsonDecode((await iokassaReques(
            user.id, pageMessage.message_id, rubForDay, balsForDay))
        .body);
    return [
      [
        Button.linked(
            text: dialogDataSource.getButtonText(
                'pay${dialogDataSource.separator}choice',
                'iokassa',
                LayoutEnum.ru),
            url: responseBody['confirmation']['confirmation_url'])
      ]
    ];
  }));

  payFor1Week.changeKeyboard(Keyboard.function((pageMessage, user) async {
    var responseBody = jsonDecode((await iokassaReques(
            user.id, pageMessage.message_id, rubForWeek, balsForWeek))
        .body);
    return [
      [
        Button.linked(
            text: dialogDataSource.getButtonText(
                'pay${dialogDataSource.separator}choice',
                'iokassa',
                LayoutEnum.ru),
            url: responseBody['confirmation']['confirmation_url'])
      ]
    ];
  }));

  payFor1Month.changeKeyboard(Keyboard.function((pageMessage, user) async {
    var responseBody = jsonDecode((await iokassaReques(
            user.id, pageMessage.message_id, rubForMonth, balsForMonth))
        .body);
    return [
      [
        Button.linked(
            text: dialogDataSource.getButtonText(
                'pay${dialogDataSource.separator}choice',
                'iokassa',
                LayoutEnum.ru),
            url: responseBody['confirmation']['confirmation_url'])
      ]
    ];
  }));

  payFor1Year.changeKeyboard(Keyboard.function((pageMessage, user) async {
    var responseBody = jsonDecode((await iokassaReques(
            user.id, pageMessage.message_id, rubForYear, balsForYear))
        .body);
    return [
      [
        Button.linked(
            text: dialogDataSource.getButtonText(
                'pay${dialogDataSource.separator}choice',
                'iokassa',
                LayoutEnum.ru),
            url: responseBody['confirmation']['confirmation_url'])
      ]
    ];
  }));
}
