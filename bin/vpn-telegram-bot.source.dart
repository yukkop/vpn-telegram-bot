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
import 'pages/main.page.dart';
import 'pages/pay/pay-instruction.page.dart';
import 'pages/rate.page.dart';
import 'pages/system/empty.page.dart';
import 'pages/system/restart.page.dart';
import 'pages/region/choice-region.page.dart';
import 'package:shelf_proxy/shelf_proxy.dart';
import 'pages/region/instruction.message.dart';
import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';

SecurityContext getSecurityContext() {
  // Bind with a secure HTTPS connection
  final chain = Platform.script.resolve('/app/bin/hostname.crt').toFilePath();
  final key = Platform.script.resolve('/app/bin/hostname.key').toFilePath();

  return SecurityContext()
    ..useCertificateChain(chain)
    ..usePrivateKey(key, password: 'dartdart');
}

Future<void> main() async {
  var domain = 'vm-bd4a57f8.na4u.ru'; // Domain for the HTTPS certificate.
  var domainEmail = 'hectic.yukkop@gmail.com';
  var certificatesDirectory = './';

  // The Certificate handler, storing at `certificatesDirectory`.
  final certificatesHandler =
      CertificatesHandlerIO(Directory(certificatesDirectory));

  // The Let's Encrypt integration tool in `staging` mode:
  final LetsEncrypt letsEncrypt =
      LetsEncrypt(certificatesHandler, production: true);

  // `shelf` Pipeline:
  var pipeline = const Pipeline().addMiddleware(logRequests());

  Loger.log('Program starting..');

  final router = Router();
  EventController(router: router).addHandlers();

  final ip = InternetAddress.anyIPv4;
  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8085');
  // final server =
  //     await serve(handler, ip, port, securityContext: getSecurityContext());

  var servers = await letsEncrypt.startSecureServer(
      handler, domain, domainEmail,
      port: port, securePort: 443, requestCertificate: false);

  var server = servers[0]; // HTTP Server.
  var serverSecure = servers[1]; // HTTPS Server.

  // Enable gzip:
  server.autoCompress = true;
  serverSecure.autoCompress = true;
  print('Serving at http://${server.address.host}:${server.port}');
  print('Serving at https://${serverSecure.address.host}:${serverSecure.port}');

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
  testPeriodChoiceRegionKeyboard();
  testPeriodInstructionKeyboard();
  emptyKeyboard();

  Registrator.removeAllMessages();
  Registrator.registrateCommand('start', startMenu.render, true);
  Registrator.listenCommands(isRemoveUseless: true);
  Registrator.listenCallbacks(restart.render);
  teledart.start();
}
