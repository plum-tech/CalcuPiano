part of 'settings.dart';

const _$ns = "ui.settings";

class I18n {
  I18n._();

  static String get title => "${_$ns}.title".tr();
  static final common = _Common._();
}

class _Common {
  _Common._();

  static const _ns = "${_$ns}.common";

  String get title => "$_ns.title".tr();

  String get lightMode => "$_ns.lightMode".tr();

  String get darkMode => "$_ns.darkMode".tr();
}
