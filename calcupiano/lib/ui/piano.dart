import 'package:auto_size_text/auto_size_text.dart';
import 'package:calcupiano/events.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:calcupiano/theme/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rettulf/rettulf.dart';

class PianoKeyboard extends StatefulWidget {
  /// For preview.
  /// If [fixedSoundpack] is set, the PianoKey will not change the soundpack wtih global.
  final SoundpackProtocol? fixedSoundpack;

  const PianoKeyboard({super.key, this.fixedSoundpack});

  @override
  State<PianoKeyboard> createState() => _PianoKeyboardState();
}

class _PianoKeyboardState extends State<PianoKeyboard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, box) {
      final keySize = Size(box.maxWidth / 5, box.maxHeight / 3);
      return [
        buildColumn0(keySize),
        buildColumn1(keySize),
        buildColumn2(keySize),
        buildColumn3(keySize),
        buildColumn4(keySize),
      ].row();
    });
  }

  Widget buildColumn0(Size size) {
    return [
      k(Note.$7, size),
      k(Note.$4, size),
      k(Note.$1, size),
    ].column();
  }

  Widget buildColumn1(Size size) {
    return [
      k(Note.$8, size),
      k(Note.$5, size),
      k(Note.$2, size),
    ].column();
  }

  Widget buildColumn2(Size size) {
    return [
      k(Note.$9, size),
      k(Note.$6, size),
      k(Note.$3, size),
    ].column();
  }

  Widget buildColumn3(Size size) {
    return [
      k(Note.$mul, size),
      k(Note.$plus, Size(size.width, size.height * 2)),
    ].column();
  }

  Widget buildColumn4(Size size) {
    return [
      k(Note.$div, size),
      k(Note.$minus, size),
      k(Note.$eq, size),
    ].column();
  }

  Widget k(Note note, Size size) {
    return PianoKey(note, fixedSoundpack: widget.fixedSoundpack).sizedIn(size);
  }
}

class PianoKey extends StatefulWidget {
  final Note note;
  final SoundpackProtocol? fixedSoundpack;

  const PianoKey(this.note, {super.key, this.fixedSoundpack});

  @override
  State<PianoKey> createState() => _PianoKeyState();
}

class _PianoKeyState extends State<PianoKey> {
  Note get note => widget.note;
  SoundpackProtocol _soundpack = R.defaultSoundpack;

  SoundpackProtocol? get _fixedSoundpack => widget.fixedSoundpack;

  @override
  void initState() {
    super.initState();
    final fixedSoundpack = _fixedSoundpack;
    if (fixedSoundpack != null) {
      _soundpack = fixedSoundpack;
    } else {
      final restoredId = H.currentSoundpackID;
      if (restoredId != null) {
        _resolve(id: restoredId).then((value) {
          _soundpack = value;
        });
      }
    }
    eventBus.on<SoundpackChangeEvent>().listen((e) {
      if (_fixedSoundpack == null) {
        _soundpack = e.newSoundpack;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildKey(context);
  }

  Widget buildKey(BuildContext context) {
    final theme = Provider.of<KeyboardThemeModel?>(context);
    Widget txt = AutoSizeText(
      note.numberedText,
      style: const TextStyle(fontSize: 24),
    ).center();
    txt = InkWell(
      child: txt,
      onTapDown: (_) async {
        eventBus.fire(KeyUserPressedEvent(note));
        await playSound();
      },
    );
    return txt.inCard(
      clip: Clip.hardEdge,
      elevation: theme?.data.elevation,
    );
  }

  Future<void> playSound() async {
    await Player.playSound(_soundpack.resolve(note));
  }
}

Future<SoundpackProtocol> _resolve({
  required String id,
}) async {
  final builtin = R.id2BuiltinSoundpacks[id];
  if (builtin != null) {
    return builtin;
  } else {
    return DB.getSoundpackById(id) ?? R.defaultSoundpack;
  }
}
