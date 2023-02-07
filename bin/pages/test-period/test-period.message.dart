import 'package:http/http.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../configurations.dart';

late final testPeriodMessage = Page(
  text: Text.function((pageMessage, user) async {
    var response = await patch(Uri.http(
        Configurations.backendHost, "/users/${user.id}/useFreePeriod"));
    return '''VPNster даёт Вам *3 дня в подарок!*''';
  }),
  renderMethod: Page.send,
);
