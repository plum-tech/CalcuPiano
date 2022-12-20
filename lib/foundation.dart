import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/converter.dart';
import 'package:calcupiano/impl/soundpack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:rettulf/rettulf.dart';
export 'package:audioplayers/audioplayers.dart';
export 'package:flutter/cupertino.dart';
export 'package:flutter/services.dart';

part 'foundation/soundpack.dart';

part 'foundation/music.dart';

part 'foundation/page.dart';

// ignore: non_constant_identifier_names
final Log = Logger();

void initFoundation() {
  Converter.registerConverter(LocalSoundFile.type, (obj) => obj.toJson(), LocalSoundFile.fromJson);
  Converter.registerConverter(LocalSoundpack.type, (obj) => obj.toJson(), LocalSoundpack.fromJson);
  Converter.registerConverter(BundledSoundFile.type, (obj) => obj.toJson(), BundledSoundFile.fromJson);
}
