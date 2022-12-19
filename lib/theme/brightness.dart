part of '../theme.dart';

class BrightnessModel with ChangeNotifier {
  Brightness _brightness;

  Brightness get brightness => _brightness;

  BrightnessModel({Brightness mode = Brightness.light}) : _brightness = mode;

  ThemeMode resolve() => brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;

  bool get isDarkMode => _brightness == Brightness.dark;

  set isDarkMode(bool isDark) {
    isDark ? _brightness = Brightness.dark : _brightness = Brightness.light;
    notifyListeners();
  }
}
