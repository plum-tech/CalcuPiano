import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/app.dart';
import 'package:calcupiano/event_handler.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (!kIsWeb) {
    final appDocDir = await getApplicationDocumentsDirectory();
    R.appDir = appDocDir.path;
    final tmpDir = await getTemporaryDirectory();
    R.tmpDir = tmpDir.path;
    await Hive.initFlutter(R.hiveDir);
  }
  try {
    R.packageInfo = await PackageInfo.fromPlatform();
  } catch (_) {}
  final settingsBox = await Hive.openBox("Settings");
  final soundpackBox = await Hive.openBox<String>("Soundpacks");
  H.box = settingsBox;
  DB.box = soundpackBox;
  // Remove prefix to unify the path
  AudioCache.instance = AudioCache(prefix: "");
  initFoundation();
  initEssential();
  EventHandler.init();
  runApp(wrapWithEasyLocalization(
    const CalcuPianoApp(),
  ));
}

Widget wrapWithEasyLocalization(Widget child) {
  return EasyLocalization(
    supportedLocales: R.supportedLocales,
    path: 'assets/l10n',
    fallbackLocale: R.defaultLocale,
    child: child,
  );
}

Future<void> initEssential() async {
  H.ensureCurrentSoundpackIdValid();
}
