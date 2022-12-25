import 'dart:ui';

import 'package:calcupiano/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class R {
  R._();

  static const defaultLocale = Locale('en');
  static const supportedLocales = [
    defaultLocale,
    Locale("zh", "CN"),
  ];

  static final version = Version(1, 0, 0);
  static late final String appDir;
  static late final String tmpDir;
  static PackageInfo? packageInfo;

  /// The soundpack directory under `assets` directory.
  static const assetsSoundpackDir = "soundpack";
  static const packageName = "net.liplum.calcupiano";
  static const customSoundpackDir = "custom_soundpack";
  static const builtSoundpackIdNs = "calcupiano";
  static const defaultSoundpack = BuiltinSoundpack("default");
  static const defaultLongToneSoundpack = BuiltinSoundpack("default_long_tone");
  static const classicSoundpack = BuiltinSoundpack("classic");
  static const builtinSoundpacks = [
    defaultSoundpack,
    defaultLongToneSoundpack,
    classicSoundpack,
  ];
  static const id2BuiltinSoundpacks = {
    "$builtSoundpackIdNs.default": defaultSoundpack,
    "$builtSoundpackIdNs.default_long_tone": defaultLongToneSoundpack,
    "$builtSoundpackIdNs.classic": classicSoundpack,
  };

  static String genBuiltinSoundpackId(String name) => "$builtSoundpackIdNs.$name";
  static List<String> supportedAudioFormat = const [
    "wav",
    "ogg",
    "mp3",
  ];
  static List<String> supportedAudioDotExtension = const [
    ".wav",
    ".ogg",
    ".mp3",
  ];

  static String get localStorageDir => isDesktop ? joinPath(appDir, packageName) : appDir;

  static String get hiveDir => joinPath(localStorageDir, "hive");

  static String get soundpacksRootDir => joinPath(localStorageDir, "soundpack");
}
