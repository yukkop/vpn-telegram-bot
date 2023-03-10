import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:teledart/model.dart';
import 'package:http/http.dart' as http;
import 'package:vpn_telegram_bot/loger.dart';
import '../configurations.dart';

import '../models/balance-increse-notify/request.model.dart'
    as balance_increse_notify;
import '../pages/pay/gratitude-pay.message.dart';
import '../pages/pay/pay.const.dart';
import '../pages/region/choice-region.page.dart';
import 'controller_interface.dart';

class EventController extends IController {
  EventController({required super.router});

  @override
  EventController addHandlers() {
    router
      ..post('/iokassa-paid', _iokassa)
      ..post('/balance-increse-notify', _balanceIncreseNotify);
    return this;
  }

  /// {
  ///   "user": {
  ///     "id": <int>,
  ///     "is_bot": <bool>,
  ///     "first_name": <string>
  ///   },
  ///   "message": {
  ///     "message_id": <int>,
  ///     "data": <int>,
  ///     "chat": {
  ///       "id": <int>,
  ///       "type": <string>
  ///     }
  ///   },
  ///   "value": <int>
  /// }
  Future<Response> _balanceIncreseNotify(Request req) async {
    var body = await req.readAsString();
    var requestModel = balance_increse_notify.Request.fromJson(body);

    if (requestModel.value == ballsForDay) {
      await paidFor1Day.render(requestModel.message, requestModel.user);
    } else if (requestModel.value == ballsForWeek) {
      await paidFor1Week.render(requestModel.message, requestModel.user);
    } else if (requestModel.value == ballsForMonth) {
      await paidFor1Month.render(requestModel.message, requestModel.user);
    } else if (requestModel.value == ballsForYear) {
      await paidFor1Year.render(requestModel.message, requestModel.user);
    }
    regionChoiceReplace.render(requestModel.message, requestModel.user);

    var response = await http.patch(Uri.http(Configurations.backendHost,
        "/users/${requestModel.user.id}/addToBalance/${requestModel.value}"));

    Loger.log('iokassa event',
        userId: requestModel.user.id.toString(),
        body: 'balance request: ${response.toString()}');
    return Response.ok("ok");
  }

  Future<Response> _balanceNotify(Request req) async {
    // TODO
    return Response.ok("ok");
  }

  Future<Response> _iokassa(Request req) async {
    var body = await req.readAsString();
    var data = jsonDecode(body)["object"];

    String description = data["description"];
    var vars = description.split(':');

    var balls = vars[7];
    var message = Message(
      message_id: int.parse(vars[3]),
      date: int.parse(vars[6]),
      chat: Chat(
        id: int.parse(vars[4]),
        type: vars[5],
      ),
    );
    var user = User(
      id: int.parse(vars[0]),
      is_bot: vars[1] == 'true' ? true : false,
      first_name: vars[2],
    );

    http.Response? response;

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

    Loger.log('iokassa event',
        userId: user.id.toString(),
        body: 'balance request: ${response.toString()}');

    /* final teleDart = GetIt.I<TeleDart>(); */

    return Response.ok('Notified');
  }
}