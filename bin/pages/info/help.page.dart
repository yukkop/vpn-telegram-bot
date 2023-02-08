import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../variables.dart';
import '../dash-board.page.dart';

final Page help = Page(
  text: Text.string(dialogDataSource.getMessage('help', LayoutEnum.ru)),
  renderMethod: Page.edit,
);

void helpKeyboard() {
  help.changeKeyboard(Keyboard.list([
    [
      Button.openPage(
          text: dialogDataSource.getButtonText('help', 'back', LayoutEnum.ru),
          key: dashBoard.getKey())
    ]
  ]));
}
