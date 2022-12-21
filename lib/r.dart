import 'package:calcupiano/foundation.dart';
import 'package:version/version.dart';

class R {
  R._();

  static final version = Version(0, 0, 1);

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
