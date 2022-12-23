import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/design/multiplatform.dart';
import 'package:calcupiano/design/theme.dart';
import 'package:calcupiano/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rettulf/rettulf.dart';
import 'package:rettulf/widget/text_span.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: "Compose ${soundpack.displayName}".text(),
        centerTitle: context.isCupertino,
        actions: [
          IconButton(icon: Icon(Icons.save_rounded), onPressed: () => onSave(context)),
        ],
      ),
      body: buildBody(context),
    );
  }

  void onSave(BuildContext ctx) {
    if (!mounted) return;
    ctx.navigator.pop();
  }

  Widget buildBody(BuildContext ctx) {
    final note2LocalFileList = note2LocalFile.entries.toList();
    return ListView.separated(
      physics: const RangeMaintainingScrollPhysics(),
      itemCount: note2LocalFileList.length,
      itemBuilder: (ctx, index) {
        final p = note2LocalFileList[index];
        return _SoundFileRow(note: p.key, file: p.value, edited: soundpack);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          thickness: 1,
        );
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
    return IntrinsicHeight(
      child: [
        [
          Text.rich([
            TextSpan(text: note.numberedText),
            const WidgetSpan(child: Icon(Icons.music_note)),
          ].textSpan(style: ctx.textTheme.headlineLarge))
              .padAll(5)
              .center(),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  final player = AudioPlayer();
                  await file.loadInto(player);
                  await player.setPlayerMode(PlayerMode.lowLatency);
                  await player.resume();
                },
                icon: Icon(Icons.play_arrow),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
            ],
          ).container(
              decoration: BoxDecoration(color: ctx.theme.backgroundColor, borderRadius: ctx.cardBorderRadiusBottom)),
        ]
            .column()
            .inCard(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
            )
            .expanded(),
        Icon(
          Icons.upload_file_outlined,
          size: 36,
        )
            .inCard(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: ctx.cardBorderRadius ?? BorderRadius.zero,
              ),
            )
            .expanded(),
      ].row(caa: CrossAxisAlignment.stretch),
    );
  }
}
