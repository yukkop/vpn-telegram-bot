import 'dart:convert';

import 'package:http/http.dart';
import 'package:vpn_telegram_bot/constants.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../configurations.dart';
import '../main.page.dart';

var priceForDay = 10;

Future<Response> iokassaReques(
    int userId, int messageId, int price, int days) async {
  var response =
      await post(Uri.https('api.yookassa.ru', "/v3/payments"), headers: {
    'Idempotence-Key': uuid.v1().toString(),
    'Content-Type': 'application/json',
    'Authorization':
        'Basic ${base64.encode(utf8.encode('606187:test_rfWl9R66FvKB3QyzwGlid8deH9YiPcReTgv3r-KFSsA'))}'
  }, body: '''{
          "amount": {
            "value": "$price",
            "currency": "RUB"
          },
          "capture": true,
          "confirmation": {
            "type": "redirect",
            "return_url": "https://t.me/Vpnster_bot"
          },
          "description": "$userId;$messageId;$price;$days"
        }''');
  return response;
}

final payFor1Day = Page(
  name: 'Страница оплаты на 1 день',
  text: Text.function((pageMessage, user) async {
    var days = 1;

    var responseBody = jsonDecode(
        (await iokassaReques(user.id, pageMessage.message_id, 100, days)).body);

    return 'Оплатите по сылке ${responseBody['confirmation']['confirmation_url']}';
  }),
  renderMethod: Page.edit,
);

final payFor1Week = Page(
  name: 'Страница оплаты на 1 неделя',
  text: Text.function((pageMessage, user) async {
    var days = 7;

    var responseBody = jsonDecode(
        (await iokassaReques(user.id, pageMessage.message_id, 300, days)).body);

    return 'Оплатите по сылке ${responseBody['confirmation']['confirmation_url']}';
  }),
  renderMethod: Page.edit,
);

final payFor1Month = Page(
  name: 'Страница оплаты на 1 месяц',
  text: Text.function((pageMessage, user) async {
    var days = 30;

    var responseBody = jsonDecode(
        (await iokassaReques(user.id, pageMessage.message_id, 700, days)).body);

    return 'Оплатите по сылке ${responseBody['confirmation']['confirmation_url']}';
  }),
  renderMethod: Page.edit,
);

late final payFor1Year = Page(
  name: 'Страница оплаты на 1 год',
  text: Text.function((pageMessage, user) async {
    var days = 361;

    var responseBody = jsonDecode(
        (await iokassaReques(user.id, pageMessage.message_id, 4000, days))
            .body);

    return 'Оплатите по сылке ${responseBody['confirmation']['confirmation_url']}';
  }),
  renderMethod: Page.edit,
);

void payKeyboard() {
  payFor1Day.changeKeyboard(Keyboard.list([
    [Button.openPage(text: 'В меню', key: mainMenuEdit.getKey())]
  ]));
  payFor1Week.changeKeyboard(Keyboard.list([
    [Button.openPage(text: 'В меню', key: mainMenuEdit.getKey())]
  ]));
  payFor1Month.changeKeyboard(Keyboard.list([
    [Button.openPage(text: 'В меню', key: mainMenuEdit.getKey())]
  ]));
  payFor1Year.changeKeyboard(Keyboard.list([
    [Button.openPage(text: 'В меню', key: mainMenuEdit.getKey())]
  ]));
}
