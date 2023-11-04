import 'package:just_audio/just_audio.dart';

class SoundController {
  AudioPlayer audioPlayer = AudioPlayer();

  final successSound = 'assets/sounds/success.mp3';
  final loadingSoung = 'assets/sounds/loading.mp3';

  Future<void> play(String name) async {
    try {
      await audioPlayer.setAsset('assets/sounds/$name');
      await audioPlayer.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}
