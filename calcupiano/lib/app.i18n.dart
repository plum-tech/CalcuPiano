part of 'app.dart';

const _ns = "app";

class I18n {
  I18n._();

  static String get soundpack => "$_ns.soundpack".tr();

  static String get sheet => "$_ns.sheet".tr();

  static String get settings => "$_ns.settings".tr();

  static String get about => "$_ns.about".tr();
}
