import 'package:flutter/cupertino.dart';

enum KeyboardDisplayMode {
  numbered,
  tonicSolfa;
}

class KeyboardData {
  final KeyboardDisplayMode displayMode;

  const KeyboardData({
    this.displayMode = KeyboardDisplayMode.numbered,
  });

  KeyboardData copyWith({
    KeyboardDisplayMode? displayMode,
  }) {
    return KeyboardData(
      displayMode: displayMode ?? this.displayMode,
    );
  }
}

class KeyboardModel with ChangeNotifier {
  KeyboardData _data;

  KeyboardData get data => _data;

  KeyboardModel([KeyboardData data = const KeyboardData()]) : _data = data;

  set data(KeyboardData newData) {
    _data = newData;
    notifyListeners();
  }
}
