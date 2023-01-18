import 'package:get_it/get_it.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:vpn_telegram_bot/callback_data.dart';
import 'package:vpn_telegram_bot/data/interfaces/dialog.data_source.interface.dart';
import 'package:vpn_telegram_bot/data/layout.enum.dart';
import 'package:vpn_telegram_bot/page.enum.dart';
import 'package:vpn_telegram_bot/page/interfaces/base-page.dart';

class EmptyPage extends BasePage {
  @override
  TeleDart get teledart => GetIt.I<TeleDart>();
  @override
  DialogDataSourceInterface get dialogDataSource =>
      GetIt.I<DialogDataSourceInterface>();

  String get separator => dialogDataSource.separator;
  @override
  String get name => PageEnum.empty.name;
  @override
  String get path => 'empty';

  @override
  void register() {
    teledart.onCallbackQuery().listen((event) {
      final data = CallbackData.fromJson(event.data ?? "pg: unknown");
      final page = data.pg;

      if (page == name) {
        if (data.prms == null) {
          // TODO throw
          return;
        }

        // Достаю регион из параметров
        final Param? previousPageName = data.prms
            ?.firstWhere((element) => element.n == 'pp'); // pp = previous page
        if (data.prms == null) {
          // TODO throw
          return;
        }

        // Собираем сетку клавиатуры
        inlineKeyboardMarkup = InlineKeyboardMarkup(inline_keyboard: [
          [
            InlineKeyboardButton(
                text:
                    dialogDataSource.getButtonText(path, 'back', LayoutEnum.ru),
                callback_data:
                    CallbackData(pg: (previousPageName as Param).v).toJson())
          ]
        ]);

        // Отправляет ответ пользователю
        render(
            chatId: event.message?.chat.id,
            renderMethod: (int chatId, String text) {
              edit(chatId, text, event.message?.message_id);
            });
      }
    });
  }
}