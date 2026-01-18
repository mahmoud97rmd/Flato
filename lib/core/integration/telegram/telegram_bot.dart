import 'package:telebot/telebot.dart';

class TelegramBot {
  final String token;
  final Telebot _bot;

  TelegramBot(this.token) : _bot = Telebot(token);

  void start() {
    _bot.start();
    _bot.onMessage((msg) {
      print("Telegram Msg: ${msg.text}");
    });
  }
}
