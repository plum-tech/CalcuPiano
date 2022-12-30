import 'package:calcupiano/foundation.dart';

class Sheet {
  final List<NodeProtocol> nodes;

  const Sheet(this.nodes);
}

abstract class NodeProtocol {}

class NoteNode implements NodeProtocol {
  final Note note;

  /// [NoteNode] indicates which note should be tapped.
  const NoteNode(this.note);
}

class BreakNode implements NodeProtocol {
  const BreakNode();
}
