import 'dart:ffi';

import 'package:get_it/get_it.dart';
import 'package:teledart/model.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:teledart/teledart.dart';
import 'package:vpn_telegram_bot/callback_data.dart';
import 'package:vpn_telegram_bot/constants.dart';
import 'package:vpn_telegram_bot/data/interfaces/dialog.data_source.interface.dart';
import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/my-giga-button.dart';
import 'package:vpn_telegram_bot/page-giga-mega-trash/registrator.dart';

class Text {
  Text.string(String string) {
    getContent = (pageMessage, user) {
      return string;
    };
  }

  Text.function(String Function(Message pageMessage, User user) function) {
    getContent = function;
  }

  late final String Function(Message pageMessage, User user) getContent;
}

class Page {
  String? name;
  late Text _text;
  late List<List<MyGigaButton>>? _keyboard;

  final _key = uuid.v1().toString();
  late Future<dynamic> Function(Message, User) render;
  late final TeleDart teleDart;
  Future<dynamic> Function(
      TeleDart, Message, User, String, InlineKeyboardMarkup?)? _renderMethod;

  Page({
    this.name,
    required Text text,
    List<List<MyGigaButton>>? keyboard, // TODO create keyboard class
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

    Registrator.registrate(_key, render);
  }

  void changeKeyboard(List<List<MyGigaButton>>? keyboard) {
    _keyboard = keyboard;
    _constructRender();
  }

  void _constructRender() {
    render = (Message pageMessage, User user) async {
      await _render(
          pageMessage: pageMessage,
          user: user,
          getText: _text.getContent,
          markup: _keyboard == null
              ? null
              : InlineKeyboardMarkup(
                  inline_keyboard: _keyboard!
                      .map((e) => e.map((e) => e.convertToTeegram()).toList())
                      .toList()),
          renderMethod: _renderMethod);
    };
  }

  String getKey() {
    return _key;
  }

  /// renderMethod by default PageInterface.send(chatId, text)
  /// ты можеш комбинироватт несколько меодов отрисовки с помощью стрелочной функции
  /// или оправить свой
  Future<void> _render({
    required Message pageMessage,
    required User user,
    required String Function(Message, User) getText,
    InlineKeyboardMarkup? markup,
    Future<dynamic> Function(
            TeleDart, Message, User, String, InlineKeyboardMarkup?)?
        renderMethod,
  }) async {
    renderMethod ??= send;

    try {
      assert(pageMessage.chat.id != null);

      String text = getText(pageMessage, user);
      if (text == '' || text == null) {
        text = 'empty';
      }

      return await renderMethod(teleDart, pageMessage, user, text, markup);
    } catch (exception, stacktrace) {
      JustGay.loger('Error',
          body: '${exception.toString()}\n${stacktrace.toString()}');
    }
  }

  @deprecated
  String stringf(String text, List<String> values) {
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
      String text, InlineKeyboardMarkup? markup) async {
    await teleDart.sendMessage(pageMessage.chat.id, text, reply_markup: markup);
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
      InlineKeyboardMarkup markup, int? messageId) async {
    if (messageId == null) {
      JustGay.loger('Warning',
          body: 'method "replase" cannot delite message if message Id is null');
    } else {
      teleDart.deleteMessage(chatId, messageId);
    }

    teleDart.sendMessage(chatId, text, reply_markup: markup);
  }

  ///
  ///
  static Future edit(TeleDart teleDart, Message pageMessage, User user,
      String text, InlineKeyboardMarkup? markup) async {
    assert(pageMessage.message_id != null);

    teleDart.editMessageText(
      text,
      chat_id: pageMessage.chat.id,
      message_id: pageMessage.message_id,
      reply_markup: markup,
    );
  }
  // end regiong
}

class Exeptor {
  static void tryCatch(Function() funk) async {
    try {
      funk();
    } catch (exception, stacktrace) {
      JustGay.loger('Ecxeption',
          body: '${exception.toString()}\n${stacktrace.toString()}');
    }
  }
}

class JustGay {
  static String path = 'logs.log';
  static void loger(String head, {String? userId, String? body}) {
    body ??= '';
    userId == null ? userId = '' : userId = '/$userId/';

    final text = '${DateTime.now()} $userId [$head] $body\n';

    final file = io.File(path);
    file.writeAsStringSync(text, mode: io.FileMode.append);

    print(text);
  }
}
