import 'package:vpn_telegram_bot/configurations.dart' as lib_config;

class Configurations {
  static final botToken = lib_config.Configurations.config['botToken'];
  static final backendHost =
      '${lib_config.Configurations.config['backend']['host']}:${lib_config.Configurations.config['backend']['port']}';
  static final iokassaToken = '${lib_config.Configurations.config['iokassa']}';
  static final botUrl = '${lib_config.Configurations.config['botUrl']}';
}
