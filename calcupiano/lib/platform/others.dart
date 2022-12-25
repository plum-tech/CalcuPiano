import 'dart:io';
import 'platform.dart';

//Override default method, to provide .io access
PlatformType get currentPlatformBackend {
  if (Platform.isWindows) return PlatformType.windows;
  if (Platform.isFuchsia) return PlatformType.fuchsia;
  if (Platform.isMacOS) return PlatformType.macOS;
  if (Platform.isLinux) return PlatformType.linux;
  if (Platform.isIOS) return PlatformType.iOS;
  return PlatformType.android;
}
