import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/sheet/sheet.dart';
import 'package:flutter/material.dart';

/// [SheetParser] is not thread-safe.
class SheetParser {
  static const char2Note = {
    "1": Note.$1,
    "2": Note.$2,
    "3": Note.$3,
    "4": Note.$4,
    "5": Note.$5,
    "6": Note.$6,
    "7": Note.$7,
    "8": Note.$8,
    "9": Note.$9,
    "+":Note.$plus,
    "-":Note.$minus,
    "*":Note.$mul,
    "/":Note.$div,
  };

  Sheet parse(String content) {
    final List<NodeProtocol> nodes = [];
    for (final c in content.characters) {
      final note = char2Note[c];
      if(note != null){
        nodes.add(NoteNode(note));
      } else if(c == " " || c == "0"){
        nodes.add(const BreakNode());
      }
    }
    return Sheet(nodes);
  }
}