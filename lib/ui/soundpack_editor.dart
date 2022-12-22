import 'package:calcupiano/db.dart';
import 'package:calcupiano/design/multiplatform.dart';
import 'package:calcupiano/extension/soundpack.dart';
import 'package:calcupiano/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

/// A Soundpack Editor should allow users to edit all properties of [SoundpackMeta].
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
          IconButton(icon: Icon(Icons.save_rounded), onPressed: () => onSave(ctx)),
        ],
      ),
      body: buildBody(ctx),
    );
  }

  void onSave(BuildContext ctx) {
    final meta = widget.soundpack.meta;
    meta.name = $name.text;
    meta.description = $description.text;
    meta.author = $author.text;
    meta.url = $url.text;
    soundpack.save();
    if (!mounted) return;
    ctx.navigator.pop();
  }

  Widget buildBody(BuildContext ctx) {
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

class UrlSoundpackEditor extends StatefulWidget {
  final UrlSoundpack soundpack;

  const UrlSoundpackEditor(this.soundpack, {super.key});

  @override
  State<UrlSoundpackEditor> createState() => _UrlSoundpackEditorState();
}

class _UrlSoundpackEditorState extends State<UrlSoundpackEditor> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
