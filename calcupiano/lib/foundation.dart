// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:ui';

import 'package:calcupiano/foundation/image_file.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:jconverter/jconverter.dart';
export 'package:calcupiano/packager.dart';
export 'package:calcupiano/db.dart';
export 'package:easy_localization/easy_localization.dart';
export 'package:calcupiano/assets.dart';
export 'foundation/file.dart';
export 'foundation/player.dart';
import 'foundation/sound_file.dart';
import 'foundation/soundpack.dart';
import 'foundation/note.dart';
import 'foundation/page.dart';
import 'package:platform_safe_func/platform_safe_func.dart';
export 'foundation/soundpack.dart';
export 'foundation/note.dart';
export 'foundation/page.dart';
export 'foundation/sound_file.dart';
export 'foundation/image_file.dart';
export 'package:platform_safe_func/platform_safe_func.dart';

final Log = Logger();
const UUID = Uuid();
final Web = Dio();
final Converter = JConverter();

Future<void> initFoundation() async {
  initConverter();
}

void initConverter() {
  Converter.logger = JConverterLogger(onError: Log.e, onInfo: print);
  // SoundFile
  Converter.addAuto(BundledSoundFile.type, BundledSoundFile.fromJson);
  Converter.addAuto(LocalSoundFile.type, LocalSoundFile.fromJson);
  Converter.addAuto(UrlSoundFile.type, UrlSoundFile.fromJson);
  // Soundpack
  Converter.addAuto(LocalSoundpack.type, LocalSoundpack.fromJson);
  Converter.addAuto(UrlSoundpack.type, UrlSoundpack.fromJson);
  // Soundpack Meta
  Converter.addAuto(SoundpackMeta.type, SoundpackMeta.fromJson);
  // ImageFile
  Converter.addAuto(LocalImageFile.type, LocalImageFile.fromJson);
  Converter.addAuto(BundledImageFile.type, BundledImageFile.fromJson);
  Converter.addAuto(UrlImageFile.type, UrlImageFile.fromJson);
}

extension ColorX on Color {
  static Color colorFromJson(dynamic json) {
    return Color(json as int);
  }

  static dynamic colorToJson(Color obj) {
    return obj.value;
  }
}
