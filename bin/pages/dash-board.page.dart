import 'dart:convert';

import 'package:http/http.dart';
import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../configurations.dart';
import '../variables.dart';
import 'main.page.dart';
import 'region/choice-region.page.dart';
import 'system/empty.page.dart';

final dashBoardText = Text.function((pageMessage, user) async {
  var response =
      await get(Uri.http(Configurations.backendHost, "/users/${user.id}"));

  var responseBody = jsonDecode(response.body);
  final username = responseBody['username'];
  final balance = responseBody['balance'];

  var message = dialogDataSource.getMessage('dash-board', LayoutEnum.ru);

  final string =
      Page.stringf(message, [username.toString(), balance.toString()]);

  return string;
});

final dashBoard = Page(
  text: dashBoardText,
  renderMethod: Page.edit,
);

void dashBoardKeyboard() {
  var a = Keyboard.list([
    [
      Button.openPage(
          text: dialogDataSource.getButtonText(
              'dash-board', 'help', LayoutEnum.ru),
          key: empty.getKey())
    ], // TODO
    [
      Button.openPage(
          text: dialogDataSource.getButtonText(
              'dash-board', 'region', LayoutEnum.ru),
          key: regionChoiceReplace.getKey())
    ],
    [Button.openPage(text: 'Назад', key: mainMenuEdit.getKey())]
  ]);

  dashBoard.changeKeyboard(a);
}
