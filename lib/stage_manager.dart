// ignore_for_file: non_constant_identifier_names

import 'package:calcupiano/design/window.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/theme/keyboard.dart';
import 'package:calcupiano/ui/piano.dart';
import 'package:calcupiano/ui/sound_explorer.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

final StageManager = StageManagerImpl._();

class StageManagerImpl {
  StageManagerImpl._();

  final _soundpackPreviewKey = const ValueKey("Soundpack Preview");
  final _soundFileExplorerKey = const ValueKey("Sound File Explorer");

  Future<void> showSoundpackPreviewOf(SoundpackProtocol soundpack, {BuildContext? ctx}) async {
    await showWindow(
      ctx: ctx,
      key: _soundpackPreviewKey,
      title: soundpack.displayName,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => KeyboardThemeModel(const KeyboardThemeData(elevation: 5)),
        child: PianoKeyboard(fixedSoundpack: soundpack),
      ),
    );
  }

  Future<void> closeSoundpackPreview({BuildContext? ctx}) async {
    closeWindowByKey(_soundpackPreviewKey, ctx: ctx);
  }

  Future<void> showSoundFileExplorer({BuildContext? ctx}) async {
    await showWindow(
      ctx: ctx,
      key: _soundFileExplorerKey,
      title: "Sound Explorer",
      builder: (_) => const SoundFileExplorer(),
    );
  }
  Future<void> closeSoundFileExplorerKey({BuildContext? ctx}) async {
    closeWindowByKey(_soundFileExplorerKey, ctx: ctx);
  }
}
