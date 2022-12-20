import 'package:calcupiano/event_handler.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

import 'R.dart';
import 'app.dart';
import 'db.dart';

void main() async {
  await Hive.initFlutter(R.hiveStorage);
  final settingsBox = await Hive.openBox("Settings");
  final soundpackBox = await Hive.openBox<String>("Soundpacks");
  H.box = settingsBox;
  H.soundpacks = SoundpackStorage(soundpackBox);
  EventHandler.init();
  _initEssential();
  runApp(const CalcuPianoApp());
}

Future<void> _initEssential() async {
  H.currentSoundpackID = R.defaultSoundpack.id;
}
