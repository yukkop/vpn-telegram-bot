import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:vpn_telegram_bot/loger.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';

import '../../configurations.dart';
import '../info/wireguard-info.message.dart';
import '../main.page.dart';
import '../info/instruction.message.dart';

// Недостаток самописной утилиты, оборачиваю множество действий под пустую страницу, хотя это не требуеться
void changeRegion(
    String regionName, teleDart, message, user, text, markup) async {
  await teleDart.deleteMessage(message.chat.id, message.message_id);

  Response response;

  response = await get(
    Uri.http(Configurations.backendHost, "/regions"),
  );

  var responseBody = jsonDecode(response.body);
  final regionId = responseBody
      .firstWhere((element) => element['regionName'] == regionName)['id'];

  await patch(
      Uri.http(Configurations.backendHost, "/users/${user.id}/changeRegion"),
      body: jsonEncode({"regionId": regionId}));

  response =
      await get(Uri.http(Configurations.backendHost, "/users/${user.id}"));

  if (response.statusCode == 400) {
    response = await post(Uri.http(Configurations.backendHost, "/users"),
        body: jsonEncode({
          "telegramId": user.id.toString(),
          "username": user.username,
          "regionId": regionId
        }));

    response =
        await get(Uri.http(Configurations.backendHost, "/users/${user.id}"));
  }

  responseBody = jsonDecode(response.body);
  final username = responseBody['username'];
  final balance = responseBody['balance'];

  if (balance > 0) {
    // send instruction
    await instruction.render(message, user);

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

      final file = File('${username}_${regionName}_VPNster.conf');
      file.writeAsStringSync(configFileBody);

      await Page.sendFile(teleDart, message.chat.id, file);
    } catch (exception, stacktrace) {
      Loger.log('TestPeriodactivate',
          userId: user.id.toString(),
          body: '${exception.toString()}\n${stacktrace.toString()}');
    }

    await wireguardInfo.render(message, user);
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
