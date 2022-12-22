import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/platform/platform.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class R {
  R._();

  static final version = Version(1, 0, 0);
  static late final String appDir;
  static PackageInfo? packageInfo;

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
    "ogg",
  ];

  static String get localStorageDir => isDesktop ? joinPath(appDir, packageName) : appDir;

  static String get hiveDir => joinPath(localStorageDir, "hive");

  static String get soundpacksRootDir => joinPath(localStorageDir, "soundpack");

  /// If you know width:
  ///   height = width * [soundpackWindowAspectRatio]
  ///
  /// If you know height:
  ///   width = height / [soundpackWindowAspectRatio]
  static const soundpackWindowAspectRatio = 4 / 3;
}
