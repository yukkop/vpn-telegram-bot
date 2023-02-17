import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../variables.dart';
import 'pay.const.dart';

final paidFor1Day = Page(
  name: 'Страница оплаты на 1 день',
  text: Text.function((pageMessage, user) async {
    var message = dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}gratitude', LayoutEnum.ru);

    return Page.stringf(message, [textForDay, rubForDay.toString()]);
  }),
  renderMethod: Page.send,
);

final paidFor1Week = Page(
  name: 'Страница оплаты на 1 неделя',
  text: Text.function((pageMessage, user) async {
    var message = dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}gratitude', LayoutEnum.ru);

    return Page.stringf(message, [textForWeek, rubForWeek.toString()]);
  }),
  renderMethod: Page.send,
);

final paidFor1Month = Page(
  name: 'Страница оплаты на 1 месяц',
  text: Text.function((pageMessage, user) async {
    var message = dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}gratitude', LayoutEnum.ru);

    return Page.stringf(message, [textForMonth, rubForMonth.toString()]);
  }),
  renderMethod: Page.send,
);

final paidFor1Year = Page(
  name: 'Страница оплаты на 1 год',
  text: Text.function((pageMessage, user) async {
    var message = dialogDataSource.getMessage(
        'pay${dialogDataSource.separator}gratitude', LayoutEnum.ru);

    return Page.stringf(message, [textForYear, rubForYear.toString()]);
  }),
  renderMethod: Page.send,
);
