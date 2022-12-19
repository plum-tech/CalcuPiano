import 'impl/soundpack.dart';

class R {
  R._();

  /// The soundpack directory under `assets` directory.
  static const assetsSoundpackDir = "soundpack";
  static const hiveStorage = "net.liplum.calcupiano";
  static const customSoundpackDir = "custom_soundpack";

  static const builtinSoundpacks = [
    BuiltinSoundpack("classic"),
    BuiltinSoundpack("default"),
  ];
}
