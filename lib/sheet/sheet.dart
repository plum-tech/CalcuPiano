import 'package:calcupiano/foundation.dart';

class Sheet {
  static const Sheet empty = Sheet([]);
  final List<NodeProtocol> nodes;

  const Sheet(this.nodes);
  @override
  String toString() => nodes.join("");
}

abstract class NodeProtocol {}

class NoteNode implements NodeProtocol {
  final Note note;

  /// [NoteNode] indicates which note should be tapped.
  const NoteNode(this.note);
  @override
  String toString() => "$note";
}

class BreakNode implements NodeProtocol {
  const BreakNode();
  @override
  String toString() => " ";
}
