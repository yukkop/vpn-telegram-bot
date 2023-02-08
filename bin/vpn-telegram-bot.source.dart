import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import 'package:vpn_telegram_bot/data/interfaces/dialog.data-source.interface.dart';
import 'package:vpn_telegram_bot/data/yaml-dialog.data-source.dart';
import 'package:vpn_telegram_bot/loger.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/registrator.hectic-tg.dart';

import 'configurations.dart';
import 'controlers/event_contoller.dart';
import 'pages/dash-board.page.dart';
import 'pages/info/help.page.dart';
import 'pages/main.page.dart';
import 'pages/pay/pay-choice.page.dart';
import 'pages/rate.page.dart';
import 'pages/system/empty.page.dart';
import 'pages/system/restart.page.dart';
import 'pages/region/choice-region.page.dart';
import 'pages/info/instruction.message.dart';

Future<void> main() async {
  Loger.log('Program starting..');

  final router = Router();
  EventController(router: router).addHandlers();

  final ip = InternetAddress.anyIPv4;
  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8085');
  final server = await serve(handler, ip, port);

  Loger.log('Server listening on port ${server.port}');

  // region setup teledart

  final username = (await Telegram(Configurations.botToken).getMe()).username;

  GetIt.I.registerSingleton<TeleDart>(
      TeleDart(Configurations.botToken, Event(username!)));

  final teledart = GetIt.I<TeleDart>();
  //endregion

  GetIt.I.registerSingleton<DialogDataSourceInterface>(YamlDialogDataSource());

  payKeyboard();
  restartKeyboard();
  rateKeyboard();
  mainKeyboard();
  dashBoardKeyboard();
  helpKeyboard();
  testPeriodChoiceRegionKeyboard();
  instructionKeyboard();
  emptyKeyboard();

  Registrator.removeAllMessages();
  Registrator.registrateCommand('start', startMenu.render, true);
  Registrator.listenCommands(isRemoveUseless: true);
  Registrator.listenCallbacks(restart.render);
  teledart.start();
}
