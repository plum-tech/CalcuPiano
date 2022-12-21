import 'web.dart' if (dart.library.io) 'others.dart';

export 'web.dart' if (dart.library.io) 'others.dart';
import 'package:path/path.dart' if (dart.library.html) 'src/stub/path.dart' show join;

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

String joinPath(String part1,
    [String? part2,
    String? part3,
    String? part4,
    String? part5,
    String? part6,
    String? part7,
    String? part8,
    String? part9,
    String? part10,
    String? part11,
    String? part12,
    String? part13,
    String? part14,
    String? part15,
    String? part16]) {
  return join(part1, part2, part3, part4, part5, part6, part7, part8, part9, part10, part11, part12, part13, part14,
      part15, part16);
}
