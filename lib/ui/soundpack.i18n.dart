part of 'soundpack.dart';

const _ns = "ui.soundpack";

class I18n {
  I18n._();
  static final op  = Op._();
  static String get title => "$_ns.title".tr();

  static String get createSoundpack => "$_ns.createSoundpack".tr();

  static String get importSoundpack => "$_ns.importSoundpack".tr();

  static String get link => "$_ns.link".tr();

  static String get localFile => "$_ns.localFile".tr();

  static String get corruptedSoundpack => "$_ns.corruptedSoundpack".tr();

  static String get corruptedSoundpackSubtitle => "$_ns.corruptedSoundpackSubtitle".tr();
}

class Op extends I18nXOp {
  Op._();
  String get compose => "$_ns.compose".tr();
}
