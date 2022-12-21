import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../foundation.dart';

/// More info about the file format of Soundpack, please see [https://github.com/liplum/calcupiano/specifications.md/Soundpack.md].
class ImportSoundpackPage extends StatefulWidget {
  const ImportSoundpackPage({super.key});

  @override
  State<ImportSoundpackPage> createState() => _ImportSoundpackPageState();
}

class _ImportSoundpackPageState extends State<ImportSoundpackPage> {
  @override
  Widget build(BuildContext context) {
    return buildMain(context);
  }

  Widget buildMain(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: "AA".text(),
      ),
    );
  }
}
