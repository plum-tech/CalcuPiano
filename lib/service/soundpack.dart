import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';

class SoundpackService{
  static SoundpackProtocol? findById(String id) {
    final builtin = R.id2BuiltinSoundpacks[id];
    if (builtin != null) {
      return builtin;
    } else {
      return DB.getSoundpackById(id);
    }
  }
}
