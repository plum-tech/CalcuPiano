import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/design/theme.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
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

  @override
  void initState() {
    super.initState();
    /*for(final id in idList){
      id2Soundpack[id] = SoundpackX.;
    }*/
    for (final builtin in R.builtinSoundpacks) {
      soundpacks.add(builtin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return [
      buildList(context).expanded(),
      VerticalDivider(),
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
            selected: selected == soundpack,
            onTap: () {
              setState(() {
                selected = soundpack;
              });
            },
          );
          return tile;
        });
  }

  Widget buildContent(BuildContext ctx) {
    final note2Files = selected.iterateNote2SoundFile().toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
    Widget res = [
      const Icon(Icons.audio_file_outlined),
      note.id.text(),
    ].column(maa: MainAxisAlignment.center);
    res = InkWell(
            borderRadius: ctx.cardBorderRadius,
            onTap: () async {
              final player = AudioPlayer();
              await file.loadInto(player);
              await player.setPlayerMode(PlayerMode.lowLatency);
              await player.resume();
            },
            child: res)
        .inCard(elevation: 6);
    final feedback = AbsorbPointer(
      child: [
        const Icon(Icons.audio_file_outlined, size: 36),
        note.id.text(style: ctx.textTheme.headlineSmall),
      ].column(maa: MainAxisAlignment.center).padAll(20.w).inCard(elevation: 6),
    );
    return LongPressDraggable<SoundFileLoc>(
      data: SoundFileLoc(selected, file),
      dragAnchorStrategy: (_, __, ___) => Offset(80.w, 80.w),
      feedback: feedback,
      child: res,
    );
  }
}
