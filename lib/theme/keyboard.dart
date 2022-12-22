import 'package:flutter/cupertino.dart';

enum KeyboardDisplayMode {
  numbered,
  tonicSolfa;
}

class KeyboardThemeData {
  final KeyboardDisplayMode displayMode;
  final double? elevation;

  const KeyboardThemeData({
    this.displayMode = KeyboardDisplayMode.numbered,
    this.elevation,
  });

  KeyboardThemeData copyWith({
    KeyboardDisplayMode? displayMode,
    double? elevation,
  }) {
    return KeyboardThemeData(
      displayMode: displayMode ?? this.displayMode,
      elevation: elevation ?? this.elevation,
    );
  }
}

class KeyboardThemeModel with ChangeNotifier {
  KeyboardThemeData _data;

  KeyboardThemeData get data => _data;

  KeyboardThemeModel([KeyboardThemeData data = const KeyboardThemeData()]) : _data = data;

  set data(KeyboardThemeData newData) {
    _data = newData;
    notifyListeners();
  }
}