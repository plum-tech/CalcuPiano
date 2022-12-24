import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/design/multiplatform.dart';
import 'package:calcupiano/design/theme.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:flutter/material.dart';
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
  late final $note2LocalFile = Map.of(soundpack.note2SoundFile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Compose ${soundpack.displayName}".text(),
        centerTitle: context.isCupertino,
        actions: [
          IconButton(
              icon: const Icon(Icons.playlist_play_outlined), onPressed: () async => await playSoundInNoteOrder()),
          IconButton(icon: const Icon(Icons.save_rounded), onPressed: () async => await onSave(context)),
        ],
      ),
      body: buildBody(context),
    );
  }

  Future<void> onSave(BuildContext ctx) async {
    // Replace old LocalSoundFile with new LocalSoundFile in sequence
    for (final note in Note.all) {
      final newFile = $note2LocalFile[note];
      final formerFile = soundpack.note2SoundFile[note];
      if (newFile != formerFile) {
        await formerFile?.tryDelete();
        if (newFile != null) {
          final ext = extensionOfPath(newFile.localPath);
          final targetPath = joinPath(R.soundpacksRootDir, soundpack.uuid, "${note.id}$ext");
          await newFile.toFile().copy(targetPath);
          // To prevent unsync due to exception, save the soundpack with new note2SoundFile each time a new LocalSoundFile is really saved.
          soundpack.note2SoundFile[note] = LocalSoundFile(localPath: targetPath);
          DB.setSoundpackSnapshotById(soundpack);
        }
      }
    }
    if (!mounted) return;
    ctx.navigator.pop();
  }

  Future<void> playSoundInNoteOrder() async {
    for (final note in Note.all) {
      final file = $note2LocalFile[note];
      if (file != null) {
        final player = AudioPlayer();
        await file.loadInto(player);
        await player.setPlayerMode(PlayerMode.lowLatency);
        await player.resume();
        // TODO: Customize interval
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  Widget buildBody(BuildContext ctx) {
    return ListView.separated(
      physics: const RangeMaintainingScrollPhysics(),
      itemCount: Note.all.length,
      itemBuilder: (ctx, index) {
        final note = Note.all[index];
        return _SoundFileRow(
          note: note,
          edited: soundpack,
          getFile: () => $note2LocalFile[note],
          setFile: (f) {
            if (f == null) {
              $note2LocalFile.remove(note);
            } else {
              $note2LocalFile[note] = f;
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(thickness: 1);
      },
    );
  }
}

class _SoundFileRow extends StatefulWidget {
  final Note note;
  final LocalSoundFile? Function() getFile;
  final void Function(LocalSoundFile? newFile) setFile;
  final SoundpackProtocol edited;

  const _SoundFileRow({
    super.key,
    required this.edited,
    required this.note,
    required this.getFile,
    required this.setFile,
  });

  @override
  State<_SoundFileRow> createState() => _SoundFileRowState();
}

class _SoundFileRowState extends State<_SoundFileRow> {
  Note get note => widget.note;

  LocalSoundFile? get file => widget.getFile();

  set file(LocalSoundFile? newFile) {
    widget.setFile(newFile);
    setState(() {});
  }

  SoundpackProtocol get edited => widget.edited;

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext ctx) {
    final sound = file;
    return IntrinsicHeight(
      child: [
        [
          buildTitle(ctx, sound),
          buildBottomBar(ctx, sound),
        ]
            .column()
            .inCard(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
            )
            .expanded(),
        buildUploadArea(ctx, sound).expanded(),
      ].row(caa: CrossAxisAlignment.stretch),
    );
  }

  Widget buildTitle(BuildContext ctx, LocalSoundFile? sound) {
    return Text.rich([
      TextSpan(text: note.numberedText),
      WidgetSpan(child: sound != null ? const Icon(Icons.music_note) : const Icon(Icons.music_off)),
    ].textSpan(style: ctx.textTheme.headlineLarge))
        .padAll(5)
        .center();
  }

  Widget buildBottomBar(BuildContext ctx, LocalSoundFile? sound) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        if (sound != null) buildPlaySoundBtn(sound),
      ],
    ).container(decoration: BoxDecoration(color: ctx.theme.backgroundColor, borderRadius: ctx.cardBorderRadiusBottom));
  }

  Widget buildUploadArea(BuildContext ctx, LocalSoundFile? sound) {
    const icon = Icon(Icons.upload_file_outlined, size: 36);
    Widget center;
    if (sound != null) {
      center = [icon, basenameOfPath(sound.localPath).text()].column(maa: MainAxisAlignment.center);
    } else {
      center = icon;
    }
    center = InkWell(
      borderRadius: ctx.cardBorderRadius,
      onTap: () async {
        final audio = await Packager.tryPickAudioFile();
        if (audio != null) {
          file = LocalSoundFile(localPath: audio);
        }
      },
      child: center,
    );
    final widget = center.inCard(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: ctx.cardBorderRadius ?? BorderRadius.zero,
      ),
    );
    return widget;
  }

  Widget buildPlaySoundBtn(LocalSoundFile file) {
    return IconButton(
      onPressed: () async {
        final player = AudioPlayer();
        await file.loadInto(player);
        await player.setPlayerMode(PlayerMode.lowLatency);
        await player.resume();
      },
      icon: const Icon(Icons.play_arrow),
    );
  }

  /// Search a SoundFile in another soundpack.
  Future<void> searchInAnother() async {}
}

/// A composition operation
abstract class _Op {
  Future<void> perform();
}

/// Replace old SoundFile with new SoundFile from different Soundpack
class _ReplaceOp implements _Op {
  @override
  Future<void> perform() {
    throw UnimplementedError();
  }
}

/// Swap two SoundFiles in the same Soundpack
class _SwapOp implements _Op {
  @override
  Future<void> perform() {
    throw UnimplementedError();
  }
}
