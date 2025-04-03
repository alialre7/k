import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _clickPlayer = AudioPlayer();
  static final AudioPlayer _player = AudioPlayer(); // ✅ التعريف هنا

  static Future<void> playClickSound() async {
    await _clickPlayer.setVolume(1.0);
    await _clickPlayer.play(AssetSource('sounds/button_click.mp3'));
  }

  static Future<void> playLogoutSound() async {
    await _player.play(AssetSource('sounds/logout.mp3'));
  }

  static Future<void> playCancelSound() async {
    await _player.play(AssetSource('sounds/cancel.mp3'));
  }
}

