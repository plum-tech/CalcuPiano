import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../foundation.dart';
import 'package:audioplayers/audioplayers.dart';
class PianoKeyboard extends StatefulWidget {
  const PianoKeyboard({super.key});

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
      PianoKey(Note.$7).sizedIn(size),
      PianoKey(Note.$4).sizedIn(size),
      PianoKey(Note.$1).sizedIn(size),
    ].column();
  }

  Widget buildColumn1(Size size) {
    return [
      PianoKey(Note.$8).sizedIn(size),
      PianoKey(Note.$5).sizedIn(size),
      PianoKey(Note.$2).sizedIn(size),
    ].column();
  }

  Widget buildColumn2(Size size) {
    return [
      PianoKey(Note.$9).sizedIn(size),
      PianoKey(Note.$6).sizedIn(size),
      PianoKey(Note.$3).sizedIn(size),
    ].column();
  }

  Widget buildColumn3(Size size) {
    return [
      PianoKey(Note.$mul).sizedIn(size),
      PianoKey(Note.$plus).sized(w: size.width, h: size.height * 2),
    ].column();
  }

  Widget buildColumn4(Size size) {
    return [
      PianoKey(Note.$div).sizedIn(size),
      PianoKey(Note.$minus).sizedIn(size),
      PianoKey(Note.$eq).sizedIn(size),
    ].column();
  }
}

class PianoKey extends StatefulWidget {
  final Note note;

  const PianoKey(this.note, {super.key});

  @override
  State<PianoKey> createState() => _PianoKeyState();
}

class _PianoKeyState extends State<PianoKey> {
  Note get note => widget.note;

  @override
  Widget build(BuildContext context) {
    return buildKey(context);
  }

  Widget buildKey(BuildContext context) {
    return AutoSizeText(
      note.number,
      style: TextStyle(fontSize: 24),
    ).center().inCard().onTap(()async {
      final player = AudioPlayer();
      await player.setSourceAsset("soundpack/default/${note.path}.wav");
      await player.setPlayerMode(PlayerMode.lowLatency);
      await player.setPlaybackRate(1);
      await player.resume();
    });
  }
}
