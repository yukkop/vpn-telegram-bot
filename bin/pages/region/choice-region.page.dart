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

List<String>? regionStaff(String regionName) {
  List<String> cortejAtvechau = List.filled(2, "");
  if (regionName == 'russia') {
    cortejAtvechau[0] = 'Россия 🇷🇺';
    cortejAtvechau[1] = changeRegionRussia.getKey();
    return cortejAtvechau;
  } else if (regionName == 'netherlands') {
    cortejAtvechau[0] = 'Нидерланды 🇳🇱';
    cortejAtvechau[1] = changeRegionNetherlands.getKey();
    return cortejAtvechau;
  }
  // else nothink
  return null;
}

void testPeriodChoiceRegionKeyboard() {
  var keyboard = Keyboard.function((pageMessage, user) async {
    var response = await get(Uri.http(Configurations.backendHost, "/regions"));

    var responseBody = jsonDecode(response.body);
    List<List<Button>> arr = [];
    for (var i in responseBody) {
      var region =
          regionStaff(i['regionName']) ?? List<String>.filled(2, "empty");

      arr.add([Button.openPage(text: region[0], key: region[1])]);
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

  regionChoiceEdit.changeKeyboard(keyboard);
  regionChoiceReplace.changeKeyboard(keyboard);
}
