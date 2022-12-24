import 'package:calcupiano/design/multiplatform.dart';
import 'package:calcupiano/design/theme.dart';
import 'package:calcupiano/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rettulf/rettulf.dart';

/// A Soundpack Editor should allow users to edit all properties of [SoundpackMeta].
/// Save button will save to storage and write into file.
///
/// Navigation will return `true` if any changed and saved.
class LocalSoundpackEditor extends StatefulWidget {
  final LocalSoundpack soundpack;

  const LocalSoundpackEditor(this.soundpack, {super.key});

  @override
  State<LocalSoundpackEditor> createState() => _LocalSoundpackEditorState();
}

class _LocalSoundpackEditorState extends State<LocalSoundpackEditor> {
  LocalSoundpack get soundpack => widget.soundpack;
  late final $name = TextEditingController(text: widget.soundpack.meta.name);
  late final $description = TextEditingController(text: widget.soundpack.meta.description);
  late final $author = TextEditingController(text: widget.soundpack.meta.author);
  late final $url = TextEditingController(text: widget.soundpack.meta.url);
  final editing = SoundpackMeta();
  late LocalImageFile? $preview = soundpack.preview;

  @override
  void initState() {
    super.initState();
    $name.addListener(() {
      // To Change the AppBar title.
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildMain(context);
  }

  Widget buildMain(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: $name.text.text(overflow: TextOverflow.clip),
        centerTitle: ctx.isCupertino,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: () async => await onSave(ctx),
          ),
        ],
      ),
      body: [
        buildPreview(ctx),
        buildMetaEditor(ctx),
      ].column().scrolled(),
    );
  }

  Widget buildPreview(BuildContext ctx) {
    final fullW = ctx.mediaQuery.size.width;
    final fullH = ctx.mediaQuery.size.height;
    final preview = $preview;
    Widget img;
    if (preview != null) {
      img = preview.build(ctx).fitted();
    } else {
      img = SvgPicture.asset(
        Assets.img.previewPlaceholder,
      ).fitted().constrained(maxW: fullW * 0.4, maxH: fullH * 0.4);
    }
    img = ClipRRect(
      borderRadius: ctx.cardBorderRadius,
      child: img,
    ).padAll(20.w);
    img = img.onTap(() async {
      final path = await Packager.pickImage();
      if (path != null) {
        if (!mounted) return;
        setState(() {
          $preview = LocalImageFile(localPath: path);
        });
      }
    });
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      child: img,
    );
  }

  Future<void> onSave(BuildContext ctx) async {
    var changed = false;
    editing.name = $name.text;
    editing.description = $description.text;
    editing.author = $author.text;
    editing.url = $url.text;
    final former = soundpack.meta;
    if (editing != former) {
      soundpack.meta = editing;
      await Packager.writeSoundpackMetaFile(soundpack);
      changed = true;
    }
    final preview = $preview;
    if (preview != soundpack.preview && preview != null) {
      soundpack.preview = await Packager.copyImageAsPreview(soundpack, sourceImagePath: preview.localPath);
      changed = true;
    }
    if (changed) {
      DB.setSoundpackSnapshotById(soundpack);
    }
    if (!mounted) return;
    ctx.navigator.pop(changed);
  }

  Widget buildMetaEditor(BuildContext ctx) {
    return Form(
      child: [
        $TextField$(
          controller: $name,
          labelText: "Soundpack Name",
        ).padSymmetric(h: 20, v: 5),
        [
          $TextField$(
            controller: $author,
            labelText: "Author",
          ).padFromLTRB(20, 5, 5, 5).flexible(flex: 1),
          $TextField$(
            controller: $url,
            labelText: "Url",
          ).padFromLTRB(5, 5, 20, 5).flexible(flex: 2),
        ].row(),
        $TextField$(
          controller: $description,
          labelText: "Description",
          maxLines: 6,
        ).padSymmetric(h: 20, v: 5),
      ].column(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    $name.dispose();
  }
}
