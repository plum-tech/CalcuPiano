// ignore_for_file: non_constant_identifier_names

import 'package:calcupiano/design/overlay.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/ui/soundpack_preview.dart';
import 'package:flutter/cupertino.dart';

final StageManager = StageManagerImpl._();

class StageManagerImpl {
  StageManagerImpl._();

  final _soundpackPreviewKey = const ValueKey("Soundpack Preview");

  Future<void> showSoundpackPreviewOf(SoundpackProtocol soundpack, {BuildContext? ctx}) async {
    late final CloseableProtocol closeable;
    final entry = showTop(
        context: ctx, key: _soundpackPreviewKey, (context) => SoundpackPreviewWindow(soundpack, closeable: closeable));
    closeable = CloseableDelegate(self: entry);
  }

  Future<void> closeSoundpackPreview({BuildContext? ctx}) async {
    final entry = getTopEntry(key: _soundpackPreviewKey, context: ctx);
    entry?.closeWindow();
  }
}
