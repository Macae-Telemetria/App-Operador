import 'package:just_audio/just_audio.dart';

class SoundController {
  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> play() async {
    try {
      await audioPlayer.setAsset('assets/sounds/success.mp3');
      await audioPlayer.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}
