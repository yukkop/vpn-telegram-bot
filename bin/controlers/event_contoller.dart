import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:teledart/model.dart';
import 'package:http/http.dart' as http;
import 'package:vpn_telegram_bot/loger.dart';
import '../configurations.dart';

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
    var data = jsonDecode(body) /* ["object"] */;

    var description = jsonDecode(data["description"]);

    /* var price = description["price"];  */
    var balls = data["balls"];
    var message = Message.fromJson(description["message"]);
    var user = User.fromJson(description["user"]);

    http.Response? response;
    print('balls: $balls');

    if (balls != null) {
      if (balls == ballsForDay.toString()) {
        await paidFor1Day.render(message, user);
      } else if (balls == ballsForWeek.toString()) {
        await paidFor1Week.render(message, user);
      } else if (balls == ballsForMonth.toString()) {
        await paidFor1Month.render(message, user);
      } else if (balls == ballsForYear.toString()) {
        await paidFor1Year.render(message, user);
      }
      regionChoiceReplace.render(message, user);

      response = await http.patch(Uri.http(
          Configurations.backendHost, "/users/${user.id}/addToBalance/$balls"));
    }

    Loger.log('iokassa event',
        userId: user.id.toString(),
        body: 'balance request: ${response.toString()}');

    /* final teleDart = GetIt.I<TeleDart>(); */

    return Response.ok('Notified');
  }
}
