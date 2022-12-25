import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/foundation.dart';

class Player {
  Player._();

  static Future<void> playSound(SoundFileProtocol sound) async {
    final player = AudioPlayer();
    await sound.loadInto(player);
    await player.setPlayerMode(PlayerMode.lowLatency);
    await player.resume();
  }
}
