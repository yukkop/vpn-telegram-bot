import 'package:get_it/get_it.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:vpn_telegram_bot/constants.dart';
import 'package:vpn_telegram_bot/loger.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/keyboard.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/text.hectic-tg.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/registrator.hectic-tg.dart';

class Page {
  String? name;
  late Text _text;
  late Keyboard? _keyboard;

  final _key = uuid.v1().toString();
  late Future<dynamic> Function(Message, User) render;
  late final TeleDart teleDart;
  Future<dynamic> Function(
      TeleDart, Message, User, String, InlineKeyboardMarkup?)? _renderMethod;

  Page.withoutRegistration({
    this.name,
    required Text text,
    Keyboard? keyboard, // TODO create keyboard class
    Future<dynamic> Function(
            TeleDart, Message, User, String, InlineKeyboardMarkup?)?
        renderMethod,
  }) {
    // DI

    teleDart = GetIt.I<TeleDart>();

    // endregion
    _text = text;
    _keyboard = keyboard;
    _renderMethod = renderMethod;

    _constructRender();
  }

  Page({
    this.name,
    required Text text,
    Keyboard? keyboard, // TODO create keyboard class
    Future<dynamic> Function(
            TeleDart, Message, User, String, InlineKeyboardMarkup?)?
        renderMethod,
  }) {
    // DI

    teleDart = GetIt.I<TeleDart>();

    // endregion
    _text = text;
    _keyboard = keyboard;
    _renderMethod = renderMethod;

    _constructRender();

    Registrator.registrateButton(_key, render);
  }

  void changeKeyboard(Keyboard? keyboard) {
    _keyboard = keyboard;
    _constructRender();
  }

  void _constructRender() {
    render = (Message pageMessage, User user) async {
      await _render(
          pageMessage: pageMessage,
          user: user,
          getText: _text.getContent,
          getMarkup: _keyboard?.getMarkup,
          renderMethod: _renderMethod);
    };
  }

  String getKey() {
    return _key;
  }

  /// renderMethod by defaultMyGigaPageInterface.send(chatId, text)
  /// ты можеш комбинироватт несколько меодов отрисовки с помощью стрелочной функции
  /// или оправить свой
  Future<void> _render({
    required Message pageMessage,
    required User user,
    required Future<String> Function(Message, User) getText,
    Future<InlineKeyboardMarkup> Function(Message pageMessage, User user)?
        getMarkup,
    Future<dynamic> Function(
            TeleDart, Message, User, String, InlineKeyboardMarkup?)?
        renderMethod,
  }) async {
    renderMethod ??= send;

    try {
      String text = await getText(pageMessage, user);
      if (text == '') {
        text = 'empty';
      }

      return await renderMethod(teleDart, pageMessage, user, text,
          getMarkup == null ? null : await getMarkup(pageMessage, user));
    } catch (exception, stacktrace) {
      Loger.log('Error',
          body: '${exception.toString()}\n${stacktrace.toString()}');
    }
  }

  static String stringf(String text, List<String> values) {
    String result = '';

    List<String> textParts = text.split('%');
    print("text valuest: $textParts");
    for (var i = 0; i < textParts.length /* */; i++) {
      if (i < values.length && i != textParts.length - 1) {
        result += textParts[i] + values[i];
      } else {
        result += textParts[i];
      }
    }

    return result;
  }

  // region render methods

  ///
  ///
  static Future send(TeleDart teleDart, Message pageMessage, User user,
      String text, InlineKeyboardMarkup? markup,
      [parseMode = "Markdown"]) async {
    await teleDart.sendMessage(
      pageMessage.chat.id,
      text,
      reply_markup: markup,
      parse_mode: parseMode,
    );
  }

  /// send a photo
  ///
  static Future sendPhoto(TeleDart teleDart, int? chatId, dynamic photo) async {
    await teleDart.sendPhoto(chatId, photo);
  }

  static Future sendFile(TeleDart teleDart, int? chatId, dynamic file) async {
    await teleDart.sendDocument(chatId, file);
  }

  /// удаляет старое сообщкние и отправляет новоре
  /// Для тех случаев когда нужно сместить интерфейс в низ диалога
  static Future replase(TeleDart teleDart, int? chatId, String text,
      InlineKeyboardMarkup? markup, int? messageId,
      [parseMode = "Markdown"]) async {
    if (messageId == null) {
      Loger.log('Warning',
          body: 'method "replase" cannot delite message if message Id is null');
    } else {
      teleDart.deleteMessage(chatId, messageId);
    }

    teleDart.sendMessage(
      chatId,
      text,
      reply_markup: markup,
      parse_mode: parseMode,
    );
  }

  ///
  ///
  static Future edit(TeleDart teleDart, Message pageMessage, User user,
      String text, InlineKeyboardMarkup? markup,
      [parseMode = "Markdown"]) async {
    try {
      if (markupEq(pageMessage.reply_markup, markup)) {
        teleDart.editMessageText(
          text,
          chat_id: pageMessage.chat.id,
          message_id: pageMessage.message_id,
          parse_mode: parseMode,
        );
      } else {
        teleDart.editMessageText(
          text,
          chat_id: pageMessage.chat.id,
          message_id: pageMessage.message_id,
          reply_markup: markup,
          parse_mode: parseMode,
        );
      }
    } catch (e) {}
  }
  // end regiong

  static bool markupEq(InlineKeyboardMarkup? a, InlineKeyboardMarkup? b) {
    if (a == null && b == null) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    if (a.toJson() == b.toJson()) {
      return true;
    }
    return false;
  }
}
