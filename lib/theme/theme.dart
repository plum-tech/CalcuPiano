import 'package:calcupiano/db.dart';
import 'package:flutter/material.dart';

class CalcuPianoThemeData {
  final bool enableRipple;
  final Brightness? brightness;

  const CalcuPianoThemeData({
    this.enableRipple = true,
    this.brightness,
  });

  const CalcuPianoThemeData.isDarkMode(
    bool? isDarkMode,
  ) : this(brightness: isDarkMode == null ? null : (isDarkMode == true ? Brightness.dark : Brightness.light));

  CalcuPianoThemeData copyWith({
    bool? enableRipple,
    Brightness? brightness,
  }) {
    return CalcuPianoThemeData(
      enableRipple: enableRipple ?? this.enableRipple,
      brightness: brightness,
    );
  }
}

extension CalcuPianoThemeDataX on CalcuPianoThemeData {
  bool get isDarkMode => brightness == Brightness.dark;
}

class CalcuPianoThemeModel with ChangeNotifier {
  CalcuPianoThemeData _data;

  CalcuPianoThemeData get data => _data;

  CalcuPianoThemeModel([CalcuPianoThemeData data = const CalcuPianoThemeData()]) : _data = data;

  set data(CalcuPianoThemeData newData) {
    _data = newData;
    notifyListeners();
  }

  ThemeMode resolveThemeMode() {
    final brightness = data.brightness;
    if (brightness == null) {
      return ThemeMode.system;
    } else if (brightness == Brightness.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }

  bool? get isDarkMode => data.brightness == null ? null : data.brightness == Brightness.dark;

  set isDarkMode(bool? isDark) {
    Brightness? brightness;
    if (isDark == null) {
      brightness == null;
    } else {
      brightness = isDark ? Brightness.dark : Brightness.light;
    }
    if (brightness != data.brightness) {
      _data = data.copyWith(
        brightness: brightness,
      );
      H.isDarkMode = isDark;
      notifyListeners();
    }
  }
}
