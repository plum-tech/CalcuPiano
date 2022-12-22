import 'package:calcupiano/design/multiplatform.dart';
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
  final $name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return buildMain(context);
  }

  Widget buildMain(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: (soundpack.meta.name ?? "No name").text(),
        centerTitle: ctx.isCupertino,
        actions: [
          CupertinoButton(child: "Done".text(), onPressed: () {}),
        ],
      ),
      body: buildBody(ctx),
    );
  }
  Widget buildBody(BuildContext ctx){
    return Placeholder();
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
