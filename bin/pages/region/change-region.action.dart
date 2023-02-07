import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:vpn_telegram_bot/loger.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../configurations.dart';
import '../main.page.dart';
import 'instruction.message.dart';

// Недостаток самописной утилиты, оборачиваю множество действий под пустую страницу, хотя это не требуеться
void changeRegion(region, teleDart, message, user, text, markup) async {
  await teleDart.deleteMessage(message.chat.id, message.message_id);
  // send instruction
  await instruction.render(message, user);

  // /users/<userId>/changeRegion
  // await patch(
  //     Uri.http(Configurations.backendHost, "/users/${user.id}/changeRegion"),
  //     body: jsonEncode({
  //       "telegramId": user.id.toString(),
  //       "username": user.username,
  //       "regionId": '4f4abb0b-063b-4a91-b944-acfbf68c3a1b'
  //     }));

  Response response;

  //check balance TODO

  //try send qr
  try {
    response = await get(
        Uri.http(Configurations.backendHost, "/users/${user.id}/qrCode"));

    final photo = File('qr.png');
    photo.writeAsBytesSync(response.body.codeUnits);

    await Page.sendPhoto(teleDart, message.chat.id, photo);
  } catch (exception, stacktrace) {
    Loger.log('TestPeriodactivate',
        userId: user.id.toString(),
        body: '${exception.toString()}\n${stacktrace.toString()}');
  }

  //try send config
  try {
    response = await get(
        Uri.http(Configurations.backendHost, "/users/${user.id}/config"));

    var configFileBody = jsonDecode(response.body)['configFile'];

    final file = File('config.conf');
    file.writeAsStringSync(configFileBody);

    await Page.sendFile(teleDart, message.chat.id, file);
  } catch (exception, stacktrace) {
    Loger.log('TestPeriodactivate',
        userId: user.id.toString(),
        body: '${exception.toString()}\n${stacktrace.toString()}');
  }

  mainMenuSend.render(message, user);
}

final changeRegionRussia = Page(
  name: 'no page',
  text: Text.string(''),
  renderMethod: (teleDart, message, user, text, markup) async {
    changeRegion('russia', teleDart, message, user, text, markup);
  },
);

final changeRegionGermany = Page(
  name: 'no page',
  text: Text.string(''),
  renderMethod: (teleDart, message, user, text, markup) async {
    changeRegion('germany', teleDart, message, user, text, markup);
  },
);

final changeRegionNetherlands = Page(
  name: 'no page',
  text: Text.string(''),
  renderMethod: (teleDart, message, user, text, markup) async {
    changeRegion('netherlands', teleDart, message, user, text, markup);
  },
);
