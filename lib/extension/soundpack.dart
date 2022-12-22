import 'package:calcupiano/db.dart';
import 'package:calcupiano/foundation/soundpack.dart';
import 'package:calcupiano/r.dart';

extension SoundpackX on SoundpackProtocol {
  static Future<SoundpackProtocol> resolve({
    required String id,
  }) async {
    final builtin = R.id2BuiltinSoundpacks[id];
    if (builtin != null) {
      return builtin;
    } else {
      return H.soundpacks.getSoundpackById(id) ?? R.defaultSoundpack;
    }
  }
}

extension ExternalSoundpackX on ExternalSoundpackProtocol {
  void save() {
    H.soundpacks.setSoundpackById(this);
  }

  void addToStorage() {
    H.soundpacks.addSoundpack(this);
  }
}
