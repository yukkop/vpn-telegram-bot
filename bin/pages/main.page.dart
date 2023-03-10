import 'dart:convert';

import 'package:http/http.dart';
import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/loger.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../configurations.dart';
import '../variables.dart';
import 'dash-board.page.dart';
import 'rate.page.dart';
import 'test-period/test-period.action.dart';

final mainMenuText =
    Text.string(dialogDataSource.getMessage('main', LayoutEnum.ru));

final startMenu = Page.withoutRegistration(
  name: 'main-menu',
  text: mainMenuText,
  renderMethod: (teleDart, pageMessage, user, text, markup) async {
    try {
      var response =
          await get(Uri.http(Configurations.backendHost, "/users/${user.id}"));

      String regionId = '4f4abb0b-063b-4a91-b944-acfbf68c3a1b';
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        regionId = responseBody['region']?['id'] ??
            '4f4abb0b-063b-4a91-b944-acfbf68c3a1b';
      }

      response = await post(Uri.http(Configurations.backendHost, "/users"),
          body: jsonEncode({
            "telegramId": user.id.toString(),
            "username": user.username,
            "regionId": regionId
          }));

      Loger.log('main-menu',
          userId: user.id.toString(),
          body: '/users status: ${response.statusCode}');

      Page.send(teleDart, pageMessage, user, text, markup);
    }
    catch (e) {
      Loger.log('Error', body: e.toString());


    }
  },
);

final mainMenuEdit = Page(
  name: 'main-menu',
  text: mainMenuText,
  renderMethod: Page.edit,
);

final mainMenuSend =
    Page(name: 'main-menu', text: mainMenuText, renderMethod: Page.send);

final mainMenuFirsTry = [
  [
    Button.openPage(
        text: dialogDataSource.getButtonText('main', 'get-vpn', LayoutEnum.ru),
        key: testPeriodAction.getKey())
  ],
  [
    Button.openPage(
        text: dialogDataSource.getButtonText('main', 'rates', LayoutEnum.ru),
        key: rate.getKey())
  ],
  [
    Button.openPage(
        text:
            dialogDataSource.getButtonText('main', 'dash-board', LayoutEnum.ru),
        key: dashBoard.getKey()),
  ]
];

final mainMenuUsualEntry = [
  [
    Button.openPage(
        text: dialogDataSource.getButtonText('main', 'rates', LayoutEnum.ru),
        key: rate.getKey())
  ],
  [
    Button.openPage(
        text:
            dialogDataSource.getButtonText('main', 'dash-board', LayoutEnum.ru),
        key: dashBoard.getKey())
  ]
];

final mainMenuKeyboard = Keyboard.function(((pageMessage, user) async {
  var response =
      await get(Uri.http(Configurations.backendHost, "/users/${user.id}"));

  var responseBody = jsonDecode(response.body);
  final freePeriodUsed = responseBody['freePeriodUsed'].toString();

  return freePeriodUsed == 'true' ? mainMenuUsualEntry : mainMenuFirsTry;
}));

void mainKeyboard() {
  startMenu.changeKeyboard(mainMenuKeyboard);
  mainMenuEdit.changeKeyboard(mainMenuKeyboard);
  mainMenuSend.changeKeyboard(mainMenuKeyboard);
}
