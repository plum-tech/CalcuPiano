part of 'soundpack.dart';

const _builtinNs = "builtinSoundpack";

class I18n {
  I18n._();
  static $I18n$Soundpack get soundpack => $I18n.soundpack;

  static String nameOf(BuiltinSoundpack s) => "$_builtinNs.${s.name}.name".tr();

  static String authorOf(BuiltinSoundpack s) => "$_builtinNs.${s.name}.author".tr();

  static String emailOf(BuiltinSoundpack s) => "$_builtinNs.${s.name}.email".tr();

  static String urlOf(BuiltinSoundpack s) => "$_builtinNs.${s.name}.url".tr();

  static String descriptionOf(BuiltinSoundpack s) => "$_builtinNs.${s.name}.description".tr();
}
