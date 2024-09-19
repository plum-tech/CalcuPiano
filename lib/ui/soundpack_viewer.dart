import 'package:calcupiano/design/multiplatform.dart';

import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rettulf/rettulf.dart';

part 'soundpack_viewer.i18n.dart';

/// A Soundpack Editor should allow users to edit all properties of [SoundpackMeta].
/// Save button will save to storage and write into file.
///
/// Navigation will return `true` if any changed and saved.
class SoundpackViewer extends StatefulWidget {
  final SoundpackProtocol soundpack;

  const SoundpackViewer(this.soundpack, {super.key});

  @override
  State<SoundpackViewer> createState() => _SoundpackViewerState();
}

class _SoundpackViewerState extends State<SoundpackViewer> {
  SoundpackProtocol get soundpack => widget.soundpack;
  late final $name = TextEditingController(text: widget.soundpack.displayName);
  late final $description = TextEditingController(text: widget.soundpack.description);
  late final $author = TextEditingController(text: widget.soundpack.author);
  late final $email = TextEditingController(text: widget.soundpack.email);
  late final $url = TextEditingController(text: widget.soundpack.url);

  @override
  Widget build(BuildContext context) {
    return buildMain(context);
  }

  Widget buildMain(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: soundpack.displayName.text(overflow: TextOverflow.clip),
        centerTitle: ctx.isCupertino,
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
    final preview = soundpack.preview;
    Widget img;
    if (preview != null) {
      img = preview.build(ctx).fitted();
    } else {
      img = SvgPicture.asset(
        Assets.img.previewPlaceholder,
        placeholderBuilder: (_) => const Icon(Icons.image_outlined),
      ).fitted().constrained(maxW: fullW * 0.4, maxH: fullH * 0.4);
    }
    img = ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: img,
    ).padAll(20);
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      child: img,
    );
  }

  Widget buildMetaEditor(BuildContext ctx) {
    return Form(
      child: [
        $TextField$(
          readOnly: true,
          controller: $name,
          labelText: I18n.soundpack.name,
        ).padSymmetric(h: 20, v: 5),
        [
          $TextField$(
            readOnly: true,
            controller: $author,
            labelText: I18n.soundpack.author,
          ).padFromLTRB(20, 5, 5, 5).flexible(flex: 1),
          $TextField$(
            readOnly: true,
            controller: $email,
            labelText: I18n.soundpack.email,
          ).padFromLTRB(5, 5, 20, 5).flexible(flex: 2),
        ].row(),
        $TextField$(
          readOnly: true,
          controller: $url,
          labelText: I18n.soundpack.url,
        ).padSymmetric(h: 20, v: 5),
        $TextField$(
          readOnly: true,
          controller: $description,
          labelText: I18n.soundpack.description,
          maxLines: 6,
        ).padSymmetric(h: 20, v: 5),
      ].column(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    $name.dispose();
    $description.dispose();
    $author.dispose();
    $email.dispose();
    $url.dispose();
  }
}
