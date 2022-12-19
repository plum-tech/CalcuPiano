import 'package:calcupiano/foundation.dart';
import 'package:rettulf/rettulf.dart';

extension BuildContextDesignX on BuildContext {
  bool get isMaterial {
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return false;
    }
  }

  bool get isCupertino => !isMaterial;
}
