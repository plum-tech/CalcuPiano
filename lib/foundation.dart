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
export 'foundation/file.dart';
import 'foundation/sound_file.dart';
import 'foundation/soundpack.dart';
import 'foundation/music.dart';
import 'foundation/page.dart';
export 'foundation/soundpack.dart';
export 'foundation/music.dart';
export 'foundation/page.dart';
export 'foundation/sound_file.dart';
export 'foundation/image_file.dart';
export 'package:calcupiano/platform/platform.dart';

final Log = Logger();
const UUID = Uuid();
final Web = Dio();

void initFoundation() {
  initConverter();
}

void initConverter() {
  // SoundFile
  Converter.registerConverter(BundledSoundFile.type, (obj) => obj.toJson(), BundledSoundFile.fromJson);
  Converter.registerConverter(LocalSoundFile.type, (obj) => obj.toJson(), LocalSoundFile.fromJson);
  Converter.registerConverter(UrlSoundFile.type, (obj) => obj.toJson(), UrlSoundFile.fromJson);
  // Soundpack
  Converter.registerConverter(LocalSoundpack.type, (obj) => obj.toJson(), LocalSoundpack.fromJson);
  Converter.registerConverter(UrlSoundpack.type, (obj) => obj.toJson(), UrlSoundpack.fromJson);
  // Soundpack Meta
  Converter.registerConverter(SoundpackMeta.type, (obj) => obj.toJson(), SoundpackMeta.fromJson);
  // ImageFile
  Converter.registerConverter(LocalImageFile.type, (obj) => obj.toJson(), LocalImageFile.fromJson);
  Converter.registerConverter(BundledImageFile.type, (obj) => obj.toJson(), BundledImageFile.fromJson);
  Converter.registerConverter(UrlImageFile.type, (obj) => obj.toJson(), UrlImageFile.fromJson);
}

extension ColorX on Color {
  static Color colorFromJson(dynamic json) {
    return Color(json as int);
  }

  static dynamic colorToJson(Color obj) {
    return obj.value;
  }
}
