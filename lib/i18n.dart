import 'package:calcupiano/platform/platform.dart';
import 'package:easy_localization/easy_localization.dart';

const _$ns = "common";

class I18nX {
  I18nX._();

  static final op = I18nXOp();
}

class I18nXOp {
  static const _ns = "${_$ns}.op";

  String get revealInFolder => (isMacOS ? "$_ns.revealInFolder.mac" : "$_ns.revealInFolder.other").tr();

  String get share => "$_ns.share".tr();

  String get saveAs => "$_ns.saveAs".tr();

  String get play$Music => "$_ns.play.music".tr();

  String get play$Game => "$_ns.play.game".tr();

  String get edit => "$_ns.edit".tr();

  String get duplicate => "$_ns.duplicate".tr();

  String get delete => "$_ns.delete".tr();
}
