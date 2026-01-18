import 'package:audioplayers/audioplayers.dart';

class AlertSoundManager {
  static final AlertSoundManager _instance = AlertSoundManager._internal();
  factory AlertSoundManager() => _instance;

  final AudioPlayer _player = AudioPlayer();

  AlertSoundManager._internal();

  Future<void> playBuy() => _player.play(AssetSource('audio/buy.mp3'));
  Future<void> playSell() => _player.play(AssetSource('audio/sell.mp3'));
}
