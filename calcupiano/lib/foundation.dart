// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:ui';

import 'package:calcupiano/converter.dart';
import 'package:calcupiano/foundation/image_file.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

export 'package:calcupiano/converter.dart';
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
export 'foundation/soundpack.dart';
export 'foundation/note.dart';
export 'foundation/page.dart';
export 'foundation/sound_file.dart';
export 'foundation/image_file.dart';
export 'package:calcupiano/platform/platform.dart';

final Log = Logger();
const UUID = Uuid();
final Web = Dio();

Future<void> initFoundation() async {
  initConverter();
}

void initConverter() {
  JConverter.logger = JConverterLogger(onError: Log.e, onInfo: print);
  // SoundFile
  JConverter.registerConvertibleAuto(BundledSoundFile.type, BundledSoundFile.fromJson);
  JConverter.registerConvertibleAuto(LocalSoundFile.type, LocalSoundFile.fromJson);
  JConverter.registerConvertibleAuto(UrlSoundFile.type, UrlSoundFile.fromJson);
  // Soundpack
  JConverter.registerConvertibleAuto(LocalSoundpack.type, LocalSoundpack.fromJson);
  JConverter.registerConvertibleAuto(UrlSoundpack.type, UrlSoundpack.fromJson);
  // Soundpack Meta
  JConverter.registerConvertibleAuto(SoundpackMeta.type, SoundpackMeta.fromJson);
  // ImageFile
  JConverter.registerConvertibleAuto(LocalImageFile.type, LocalImageFile.fromJson);
  JConverter.registerConvertibleAuto(BundledImageFile.type, BundledImageFile.fromJson);
  JConverter.registerConvertibleAuto(UrlImageFile.type, UrlImageFile.fromJson);
}

extension ColorX on Color {
  static Color colorFromJson(dynamic json) {
    return Color(json as int);
  }

  static dynamic colorToJson(Color obj) {
    return obj.value;
  }
}
