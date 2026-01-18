import 'package:audioplayers/audioplayers.dart';

class AlertSound {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playBuy() => _player.play(AssetSource('audio/buy.mp3'));
  Future<void> playSell() => _player.play(AssetSource('audio/sell.mp3'));
}
