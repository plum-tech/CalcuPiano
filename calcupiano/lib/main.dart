import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/app.dart';
import 'package:calcupiano/event_handler.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:calcupiano/service/soundpack.dart';
import 'package:calcupiano/sheet/interpreter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
  await initFoundation();
  await initEssential();
  initLicense();
  runApp(wrapWithEasyLocalization(
    const CalcuPianoApp(),
  ));
  await preloadCurrentSoundpack();
}

Widget wrapWithEasyLocalization(Widget child) {
  return EasyLocalization(
    supportedLocales: R.supportedLocales,
    path: 'assets/l10n',
    fallbackLocale: R.defaultLocale,
    child: child,
  );
}

Future<void> preloadCurrentSoundpack() async {
  final currentSoundpack = SoundpackService.findById(H.currentSoundpackID) ?? R.defaultSoundpack;
  await Player.preloadSoundpack(currentSoundpack);
}

Future<void> initEssential() async {
  H.ensureCurrentSoundpackIdValid();
  EventHandler.init();
  SheetInterpreter.init();
}

void initLicense() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString("assets/google_fonts/JetBrainsMono-OFL.txt");
    yield LicenseEntryWithLineBreaks(["JetBrains Mono"], license);
  });
}
