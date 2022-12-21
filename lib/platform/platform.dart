import 'web.dart' if (dart.library.io) 'others.dart';

export 'web.dart' if (dart.library.io) 'others.dart';

enum PlatformType { web, windows, linux, macOS, android, fuchsia, iOS }

PlatformType get currentPlatform => currentPlatformBackend;

bool get isWeb => currentPlatformBackend == PlatformType.web;

bool get isMacOS => currentPlatformBackend == PlatformType.macOS;

bool get isWindows => currentPlatformBackend == PlatformType.windows;

bool get isLinux => currentPlatformBackend == PlatformType.linux;

bool get isAndroid => currentPlatformBackend == PlatformType.android;

bool get isIOS => currentPlatformBackend == PlatformType.iOS;

bool get isFuchsia => currentPlatformBackend == PlatformType.fuchsia;

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
