import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../region/choice-region.page.dart';
import 'test-period.message.dart';

final testPeriodAction = Page(
    text: Text.string('action'),
    renderMethod: (teleDart, message, user, text, markup) async {
      await testPeriodMessage.render(message, user);
      regionChoiceReplace.render(message, user);
    });
