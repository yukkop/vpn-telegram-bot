import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../variables.dart';
import 'main.page.dart';
import 'pay/pay-choice.page.dart';
import 'pay/pay.const.dart';

late final rate = Page(
  text: Text.function((pageMessage, user) async {
    return dialogDataSource.getMessage('rate', LayoutEnum.ru);
  }),
  renderMethod: Page.edit,
);

void rateKeyboard() {
  rate.changeKeyboard(Keyboard.function((pageMessage, user) async {
    var message =
        dialogDataSource.getButtonText('rate', 'choice', LayoutEnum.ru);
    return [
      [
        Button.openPage(
            text: Page.stringf(message, [textForDay, rubForDay.toString()]),
            key: payFor1Day.getKey())
      ],
      [
        Button.openPage(
            text: Page.stringf(message, [textForWeek, rubForWeek.toString()]),
            key: payFor1Week.getKey())
      ],
      [
        Button.openPage(
            text: Page.stringf(message, [textForMonth, rubForMonth.toString()]),
            key: payFor1Month.getKey())
      ],
      [
        Button.openPage(
            text: Page.stringf(message, [textForYear, rubForYear.toString()]),
            key: payFor1Year.getKey())
      ],
      [Button.openPage(text: 'Назад', key: mainMenuEdit.getKey())]
    ];
  }));
}
