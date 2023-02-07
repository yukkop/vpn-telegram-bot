import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../variables.dart';
import 'main.page.dart';
import 'pay/pay-choice.page.dart';

late final rate = Page(
  text: Text.function((pageMessage, user) async {
    return dialogDataSource.getMessage('rate', LayoutEnum.ru);
  }),
  renderMethod: Page.edit,
);

void rateKeyboard() {
  rate.changeKeyboard(Keyboard.list([
    [
      Button.openPage(
          text: dialogDataSource.getButtonText('rate', 'day', LayoutEnum.ru),
          key: payFor1Day.getKey())
    ],
    [
      Button.openPage(
          text: dialogDataSource.getButtonText('rate', 'week', LayoutEnum.ru),
          key: payFor1Week.getKey())
    ],
    [
      Button.openPage(
          text: dialogDataSource.getButtonText('rate', 'month', LayoutEnum.ru),
          key: payFor1Month.getKey())
    ],
    [
      Button.openPage(
          text: dialogDataSource.getButtonText('rate', 'year', LayoutEnum.ru),
          key: payFor1Year.getKey())
    ],
    [Button.openPage(text: 'Назад', key: mainMenuEdit.getKey())]
  ]));
}
