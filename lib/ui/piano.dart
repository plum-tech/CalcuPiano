import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

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
      PianoKey(note: "7").sizedIn(size),
      PianoKey(note: "4").sizedIn(size),
      PianoKey(note: "1").sizedIn(size),
    ].column();
  }

  Widget buildColumn1(Size size) {
    return [
      PianoKey(note: "8").sizedIn(size),
      PianoKey(note: "5").sizedIn(size),
      PianoKey(note: "2").sizedIn(size),
    ].column();
  }

  Widget buildColumn2(Size size) {
    return [
      PianoKey(note: "9").sizedIn(size),
      PianoKey(note: "6").sizedIn(size),
      PianoKey(note: "3").sizedIn(size),
    ].column();
  }

  Widget buildColumn3(Size size) {
    return [
      PianoKey(note: "x").sizedIn(size),
      PianoKey(note: "+").sized(w: size.width, h: size.height * 2),
    ].column();
  }

  Widget buildColumn4(Size size) {
    return [
      PianoKey(note: "/").sizedIn(size),
      PianoKey(note: "-").sizedIn(size),
      PianoKey(note: "=").sizedIn(size),
    ].column();
  }
}

class PianoKey extends StatefulWidget {
  final String note;

  const PianoKey({super.key, required this.note});

  @override
  State<PianoKey> createState() => _PianoKeyState();
}

class _PianoKeyState extends State<PianoKey> {
  String get note => widget.note;

  @override
  Widget build(BuildContext context) {
    return buildKey(context);
  }

  Widget buildKey(BuildContext context) {
    return AutoSizeText(
      note,
      style: TextStyle(fontSize: 24),
    ).center().inCard();
  }
}
