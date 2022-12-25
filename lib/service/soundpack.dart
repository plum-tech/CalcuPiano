import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';

class SoundpackService {
  static SoundpackProtocol? findById(String? id) {
    if(id == null) return null;
    final builtin = R.id2BuiltinSoundpacks[id];
    if (builtin != null) {
      return builtin;
    } else {
      return DB.getSoundpackById(id);
    }
  }

  static Iterable<String> iterateAllSoundpackIds() sync* {
    yield* R.id2BuiltinSoundpacks.keys;
    final idList = H.externalSoundpackIdList;
    if (idList != null) {
      yield* idList;
    }
  }

  static Iterable<SoundpackProtocol> iterateAllSoundpacks() sync* {
    for (final id in iterateAllSoundpackIds()) {
      final soundpack = findById(id);
      if (soundpack != null) {
        yield soundpack;
      }
    }
  }
}
