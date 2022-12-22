import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/app.dart';
import 'package:calcupiano/db.dart';
import 'package:calcupiano/event_handler.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDire = await getApplicationDocumentsDirectory();
  R.appDir = appDocDire.path;
  try {
    R.packageInfo = await PackageInfo.fromPlatform();
  } catch (_) {}
  await Hive.initFlutter(R.hiveDir);
  final settingsBox = await Hive.openBox("Settings");
  final soundpackBox = await Hive.openBox<String>("Soundpacks");
  H.box = settingsBox;
  H.soundpacks = SoundpackStorage(soundpackBox);
  // Remove prefix to unify the path
  AudioCache.instance = AudioCache(prefix: "");
  initFoundation();
  initEssential();
  EventHandler.init();
  runApp(const CalcuPianoApp());
}

Future<void> initEssential() async {
  H.ensureCurrentSoundpackIdValid();
}
