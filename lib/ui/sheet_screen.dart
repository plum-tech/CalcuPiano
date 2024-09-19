import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/sheet/interpreter.dart';
import 'package:calcupiano/sheet/parser.dart';
import 'package:calcupiano/sheet/sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rettulf/rettulf.dart';

class SheetScreen extends StatefulWidget {
  const SheetScreen({super.key});

  @override
  State<SheetScreen> createState() => _SheetScreenState();
}

const _test = """
33455432 1123322 33455432 1123211
""";

class _SheetScreenState extends State<SheetScreen> {
  @override
  void initState() {
    super.initState();
    final sheet = SheetParser().parse(_test);
    SheetInterpreter.sheet = sheet;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, box) {
      final cells = <Widget>[];
      for (int i = 0; i < SheetInterpreter.sheet.nodes.length; i++) {
        final node = SheetInterpreter.sheet.nodes[i];
        if (node is NoteNode) {
          cells.add(NoteCell(note: node.note, index: i));
        } else {
          cells.add(SizedBox());
        }
      }
      return GridView.extent(
        physics: const NeverScrollableScrollPhysics(),
        maxCrossAxisExtent: 60,
        children: cells,
      );
    });
    return SheetInterpreter.sheet.toString().text();
  }
}

class NoteCell extends StatelessWidget {
  final Note note;
  final int index;

  const NoteCell({
    super.key,
    required this.note,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return note.numberedText.text(style: GoogleFonts.jetBrainsMono(fontSize: 30)).center();
  }
}
