import 'package:calcupiano/platform/platform.dart';
import 'package:easy_localization/easy_localization.dart';

const _$ns = "common";

class $I18n {
  $I18n._();

  static final op = $I18n$Op();
  static final soundpack = $I18n$Soundpack();
}

class $I18n$Soundpack {
  static const _ns = "${_$ns}.soundpack";

  String get name => "$_ns.name".tr();

  String get nameEmpty => "$_ns.nameEmpty".tr();

  String get author => "$_ns.author".tr();

  String get authorEmpty => "$_ns.authorEmpty".tr();

  String get description => "$_ns.description".tr();

  String get descriptionEmpty => "$_ns.descriptionEmpty".tr();

  String get email => "$_ns.email".tr();

  String get url => "$_ns.url".tr();
}

class $I18n$Op {
  static const _ns = "${_$ns}.operation";

  String get revealInFolder => (isMacOS ? "$_ns.revealInFolder.mac" : "$_ns.revealInFolder.other").tr();

  String get share => "$_ns.share".tr();

  String get saveAs => "$_ns.saveAs".tr();

  String get play$Music => "$_ns.play.music".tr();

  String get play$Game => "$_ns.play.game".tr();

  String get edit => "$_ns.edit".tr();

  String get info => "$_ns.info".tr();

  String get duplicate => "$_ns.duplicate".tr();

  String get delete => "$_ns.delete".tr();
}
