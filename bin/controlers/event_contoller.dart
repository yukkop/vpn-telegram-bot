import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:http/http.dart' as http;
import 'package:vpn_telegram_bot/loger.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/button.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';
import '../configurations.dart';

import '../pages/main.page.dart';
import '../pages/pay/gratitude-pay.message.dart';
import '../pages/pay/pay.const.dart';
import '../pages/region/choice-region.page.dart';
import 'controller_interface.dart';

class EventController extends IController {
  EventController({required super.router});

  @override
  EventController addHandlers() {
    router.post('/iokassa-paid', _iokassa);
    return this;
  }

  Future<Response> _iokassa(Request req) async {
    var body = await req.readAsString();
    var data = jsonDecode(body)["object"];

    String description = data["description"];
    var vars = description.split(';');
    var userId = vars[0];
    var messageId = vars[0];
    var days = vars[3];

    var fakeMessage = Message(
        message_id: int.parse(messageId),
        date: 0,
        chat: Chat(id: int.parse(userId), type: 'private'));
    var fakeUser =
        User(id: int.parse(userId), is_bot: false, first_name: 'np way');

    if (days == balsForDay.toString()) {
      await paidFor1Day.render(fakeMessage, fakeUser);
    } else if (days == balsForWeek.toString()) {
      await paidFor1Week.render(fakeMessage, fakeUser);
    } else if (days == balsForMonth.toString()) {
      await paidFor1Month.render(fakeMessage, fakeUser);
    } else if (days == balsForYear.toString()) {
      await paidFor1Year.render(fakeMessage, fakeUser);
    }
    regionChoiceReplace.render(fakeMessage, fakeUser);
    var response = await http.patch(Uri.http(
        Configurations.backendHost, "/users/$userId/addToBalance/$days"));

    Loger.log('iokassa event',
        userId: userId, body: 'balance request: $response');

    final teleDart = GetIt.I<TeleDart>();

    // teleDart.sendMessage(380055934, body);

    return Response.ok('Notified');
  }
}
