import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:calcupiano/service/soundpack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

class SoundFileExplorer extends StatefulWidget {
  const SoundFileExplorer({super.key});

  @override
  State<SoundFileExplorer> createState() => _SoundFileExplorerState();
}

class _SoundFileExplorerState extends State<SoundFileExplorer> {
  final List<SoundpackProtocol> soundpacks = [];
  SoundpackProtocol selected = R.defaultSoundpack;
  static String? lastSelectedId;

  @override
  void initState() {
    super.initState();
    soundpacks.addAll(SoundpackService.iterateAllSoundpacks());
    final lastSelected = SoundpackService.findById(lastSelectedId);
    if (lastSelected != null) {
      selected = lastSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return [
      buildList(context).expanded(),
      const VerticalDivider(),
      buildContent(context).expanded(),
    ].row(mas: MainAxisSize.min);
  }

  Widget buildList(BuildContext ctx) {
    return ListView.builder(
        itemCount: soundpacks.length,
        itemBuilder: (ctx, i) {
          final soundpack = soundpacks[i];
          final tile = ListTile(
            title: soundpack.displayName.text(),
            selected: selected.idEquals(soundpack),
            onTap: () {
              setState(() {
                selected = soundpack;
                lastSelectedId = soundpack.id;
              });
            },
          );
          return tile;
        });
  }

  Widget buildContent(BuildContext ctx) {
    final note2Files = selected.iterateNote2SoundFile().toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 80),
      itemCount: note2Files.length,
      itemBuilder: (BuildContext context, int index) {
        final p = note2Files[index];
        final note = p.key;
        final file = p.value;
        return buildSoundFile(ctx, note, file);
      },
    );
  }

  Widget buildSoundFile(BuildContext ctx, Note note, SoundFileProtocol file) {
    final feedback = AbsorbPointer(
      child: [
        const Icon(Icons.audio_file_outlined, size: 36),
        note.id.text(style: ctx.textTheme.headlineSmall),
      ].column(maa: MainAxisAlignment.center).padAll(10.w).inCard(
            elevation: 6,
          ),
    );
    return LongPressDraggable<SoundFileLoc>(
      data: SoundFileLoc.fromSoundpackType(selected, note),
      dragAnchorStrategy: (_, __, ___) => Offset(60.w, 80.w),
      feedback: feedback,
      child: InkWell(
              onTap: () async {
                Player.playSound(file);
              },
              child: [
                const Icon(Icons.audio_file_outlined),
                note.id.text(),
              ].column(maa: MainAxisAlignment.center))
          .inCard(
        clip: Clip.hardEdge,
        elevation: 6,
      ),
    );
  }
}
