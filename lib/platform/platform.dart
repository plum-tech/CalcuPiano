import 'web.dart' if (dart.library.io) 'others.dart';

export 'web.dart' if (dart.library.io) 'others.dart';
import 'package:path/path.dart' if (dart.library.html) 'web.dart' as path_helper;

enum PlatformType { web, windows, linux, macOS, android, fuchsia, iOS }

PlatformType get currentPlatform => currentPlatformBackend;

bool get isWeb => currentPlatformBackend == PlatformType.web;

bool get isMacOS => currentPlatformBackend == PlatformType.macOS;

bool get isWindows => currentPlatformBackend == PlatformType.windows;

bool get isLinux => currentPlatformBackend == PlatformType.linux;

bool get isAndroid => currentPlatformBackend == PlatformType.android;

bool get isIOS => currentPlatformBackend == PlatformType.iOS;

bool get isFuchsia => currentPlatformBackend == PlatformType.fuchsia;

bool get isDesktop => isWindows || isLinux || isMacOS;

bool get isMobile => isAndroid || isIOS;

bool get isSupportShareFiles => isAndroid || isIOS || isMacOS || isWeb;

String get osName {
  switch (currentPlatformBackend) {
    case PlatformType.web:
      return "Web";
    case PlatformType.macOS:
      return "macOS";
    case PlatformType.windows:
      return "Windows";
    case PlatformType.linux:
      return "Linux";
    case PlatformType.android:
      return "Android";
    case PlatformType.iOS:
      return "iOS";
    case PlatformType.fuchsia:
      return "Fuchsia";
  }
}

String joinPath(
  String part1, [
  String? part2,
  String? part3,
  String? part4,
  String? part5,
  String? part6,
  String? part7,
  String? part8,
]) {
  return path_helper.join(part1, part2, part3, part4, part5, part6, part7, part8);
}

String basenameOfPath(String path) => path_helper.basename(path);

String extensionOfPath(String path, [int level = 1]) => path_helper.extension(path, level);
