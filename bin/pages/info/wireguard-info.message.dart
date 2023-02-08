import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../variables.dart';

final wireguardInfo = Page(
  text:
      Text.string(dialogDataSource.getMessage('wireguard-info', LayoutEnum.ru)),
  renderMethod: Page.send,
);
