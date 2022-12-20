import 'package:calcupiano/foundation.dart';

import 'impl/soundpack.dart';

class R {
  R._();

  /// The soundpack directory under `assets` directory.
  static const assetsSoundpackDir = "soundpack";
  static const hiveStorage = "net.liplum.calcupiano";
  static const customSoundpackDir = "custom_soundpack";
  static const builtSoundpackIdNs = "calcupiano";
  static const defaultSoundpack = BuiltinSoundpack("default");
  static const builtinSoundpacks = [
    defaultSoundpack,
    BuiltinSoundpack("classic"),
  ];
  static const id2BuiltinSoundpacks = {
    "$builtSoundpackIdNs.default": defaultSoundpack,
    "$builtSoundpackIdNs.classic": BuiltinSoundpack("classic"),
  };

  static String genBuiltinSoundpackId(String name) => "$builtSoundpackIdNs.$name";
}
