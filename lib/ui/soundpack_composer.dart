import 'package:calcupiano/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rettulf/rettulf.dart';

class SoundpackComposer extends StatefulWidget {
  final LocalSoundpack soundpack;

  const SoundpackComposer(this.soundpack, {super.key});

  @override
  State<SoundpackComposer> createState() => _SoundpackComposerState();
}

class _SoundpackComposerState extends State<SoundpackComposer> {
  LocalSoundpack get soundpack => widget.soundpack;
  late final note2LocalFile = Map.of(soundpack.note2SoundFile);

  @override
  Widget build(BuildContext context) {
    final note2LocalFileList = note2LocalFile.entries.toList();
    return MasonryGridView.count(
      crossAxisCount: 2,
      itemCount: note2LocalFileList.length,
      itemBuilder: (ctx, index) {
        final p = note2LocalFileList[index];
        return _SoundFileRow(note: p.key, file: p.value, edited: soundpack);
      },
    );
  }
}

class _SoundFileRow extends StatefulWidget {
  final Note note;
  final LocalSoundFile file;
  final SoundpackProtocol edited;

  const _SoundFileRow({
    super.key,
    required this.edited,
    required this.note,
    required this.file,
  });

  @override
  State<_SoundFileRow> createState() => _SoundFileRowState();
}

class _SoundFileRowState extends State<_SoundFileRow> {
  Note get note => widget.note;

  LocalSoundFile get file => widget.file;

  SoundpackProtocol get edited => widget.edited;

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext ctx) {
    return [
      note.numberedText.text(),
    ].column().inCard();
  }
}
