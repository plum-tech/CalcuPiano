import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/foundation.dart';
import 'package:flutter/foundation.dart';

class Player {
  Player._();
  static Future<void> playSound(SoundFileProtocol sound) async {
    // TODO: Cache doesn't work on both iOS and macOS safari with audioplayers.
    final player = AudioPlayer(playerId: sound.id);
    await sound.loadInto(player);
    await player.setPlayerMode(PlayerMode.lowLatency);
    await player.setReleaseMode(ReleaseMode.stop);
    await player.resume();
  }

  /// Clear all cache.
  /// It's no effect on web.
  static void resetPhysicalDeviceCache() async {
    if (!kIsWeb) {
      AudioCache.instance.clearAll();
    }
  }

  static final Set<String> _preloadedId = {};

  /// Preload the soundpack by [SoundpackProtocol.id].
  /// It could mess with edited soundpack, however, the sound will load again before really played.
  ///
  /// Modern browsers will handle caching of GET request, this only aims at prompting the browser to cache.
  static Future<void> preloadSoundpack(SoundpackProtocol soundpack) async {
    if (!_preloadedId.contains(soundpack.id)) {
      _preloadedId.add(soundpack.id);
      final player = AudioPlayer();
      for (final note in Note.all) {
        final soundFile = soundpack.resolve(note);
        await soundFile.loadInto(player);
      }
    }
  }
}
