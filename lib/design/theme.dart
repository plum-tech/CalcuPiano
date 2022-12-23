import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

extension ThemeBuildContextX on BuildContext {
  BorderRadius? get cardBorderRadius =>
      (theme.cardTheme.shape as RoundedRectangleBorder?)?.borderRadius as BorderRadius?;
}
