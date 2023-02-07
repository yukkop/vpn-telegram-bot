import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../variables.dart';
import '../main.page.dart';
import 'choice-region.page.dart';

late final instruction = Page(
  text: Text.string(dialogDataSource.getMessage(
      'region${dialogDataSource.separator}instruction', LayoutEnum.ru)),
  renderMethod: Page.send,
);

void testPeriodInstructionKeyboard() {
  instruction.changeKeyboard(
    Keyboard.list([
      [
        Button.linked(
            text: dialogDataSource.getButtonText(
                'region${dialogDataSource.separator}instruction',
                'download',
                LayoutEnum.ru),
            url: 'https://www.wireguard.com/install/')
      ]
    ]),
  );
}
