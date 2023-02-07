import 'package:teledart/model.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/page.hectic-tg.dart';

class Button {
  final String text;
  String? url;
  late final String callbackData;

  Button.openPage({required this.text, required String key}) {
    callbackData = key;
  }
  Button.handle({required this.text}) {
// TODO
    callbackData = '';
  }

  Button.linked({required this.text, required this.url});

  InlineKeyboardButton convertToTeegram() {
    if (url == null) {
      return InlineKeyboardButton(text: text, callback_data: callbackData);
    } else {
      return InlineKeyboardButton(text: text, url: url);
    }
  }
}
