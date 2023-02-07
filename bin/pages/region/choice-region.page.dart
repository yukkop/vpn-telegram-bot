import 'dart:convert';

import 'package:http/http.dart';
import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../configurations.dart';
import '../../variables.dart';
import '../main.page.dart';
import 'change-region.action.dart';

final regionChoiceEdit = Page(
  text: Text.string(dialogDataSource.getMessage(
      'region${dialogDataSource.separator}choice-region', LayoutEnum.ru)),
  renderMethod: Page.edit,
);

final regionChoiceReplace = Page(
  text: Text.string(dialogDataSource.getMessage(
      'region${dialogDataSource.separator}choice-region', LayoutEnum.ru)),
  renderMethod: (teleDart, message, user, text, markup) async {
    Page.replase(teleDart, message.chat.id, text, markup, message.message_id);
  },
);

void testPeriodChoiceRegionKeyboard() {
  var keyboard = Keyboard.function((pageMessage, user) async {
    var response = await get(Uri.http(Configurations.backendHost, "/regions"));

    var responseBody = jsonDecode(response.body);
    List<List<Button>> arr = [];
    for (var i in responseBody) {
      arr.add([
        Button.openPage(
            text: (i['regionName'] == 'russia'
                ? 'Русский 🇷🇺'
                : 'Германия 🇩🇪'),
            key: (i['regionName'] == 'russia'
                ? changeRegionRussia.getKey()
                : changeRegionGermany.getKey()))
      ]);
    }
    arr.add([
      Button.openPage(
          text: dialogDataSource.getButtonText(
              'region${dialogDataSource.separator}choice-region',
              'back',
              LayoutEnum.ru),
          key: mainMenuEdit.getKey())
    ]);

    return arr;
  });

  List<String>? regionStaff(String regionName) {
    List<String> cortejAtvechau = List.empty();
    if (regionName == 'russia') {
      cortejAtvechau.add('');
      cortejAtvechau.add('');
    } else if (regionName == 'russia') {
      cortejAtvechau.add('');
      cortejAtvechau.add('');
    } else if (regionName == 'russia') {
      cortejAtvechau.add('');
      cortejAtvechau.add('');
    }
    return null;
  }

  regionChoiceEdit.changeKeyboard(keyboard);
  regionChoiceReplace.changeKeyboard(keyboard);
}
