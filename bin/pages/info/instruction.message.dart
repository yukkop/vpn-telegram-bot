import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../variables.dart';

final instruction = Page(
  text: Text.string(dialogDataSource.getMessage('instruction', LayoutEnum.ru)),
  renderMethod: Page.send,
);

void instructionKeyboard() {
  instruction.changeKeyboard(
    Keyboard.list([
      [
        Button.linked(
            text: dialogDataSource.getButtonText(
                'instruction', 'download', LayoutEnum.ru),
            url: 'https://www.wireguard.com/install/')
      ]
    ]),
  );
}
