part of 'settings.dart';

const _$ns = "ui.settings";

class I18n {
  I18n._();

  static String get title => "${_$ns}.title".tr();
  static final appearance = _Appearance._();
}

class _Appearance {
  _Appearance._();

  static const _ns = "${_$ns}.appearance";

  String get name => "$_ns.name".tr();

  String get brightness => "$_ns.brightness".tr();

  String get language => "$_ns.language".tr();

  String themeMode(bool isDarkMode) => isDarkMode ? darkMode : lightMode;

  String get lightMode => "$_ns.lightMode".tr();

  String get darkMode => "$_ns.darkMode".tr();
}
