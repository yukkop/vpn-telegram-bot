import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../variables.dart';
import '../main.page.dart';

final Page empty = Page(
  text: Text.string(dialogDataSource.getMessage(
      'system${dialogDataSource.separator}empty', LayoutEnum.ru)),
  renderMethod: Page.edit,
);

void emptyKeyboard() {
  empty.changeKeyboard(Keyboard.list([
    [
      Button.openPage(
          text: dialogDataSource.getButtonText(
              'system${dialogDataSource.separator}empty', 'ok', LayoutEnum.ru),
          key: mainMenuEdit.getKey())
    ]
  ]));
}
