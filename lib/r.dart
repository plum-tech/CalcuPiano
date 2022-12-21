import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/platform/platform.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class R {
  R._();

  static final version = Version(0, 0, 1);
  static late final String appDir;
  static PackageInfo? pkgInfo;

  /// The soundpack directory under `assets` directory.
  static const assetsSoundpackDir = "soundpack";
  static const packageName = "net.liplum.calcupiano";
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
  static List<String> supportedAudioFormat = const [
    "wav",
    "mp3",
  ];

  static String get localStorageDir => isDesktop ? joinPath(appDir, packageName) : appDir;

  static String get hiveDir => joinPath(localStorageDir, "hive");
  static String get soundpacksRootDir => joinPath(localStorageDir,"soundpack");
}
