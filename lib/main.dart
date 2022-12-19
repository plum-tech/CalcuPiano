import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

import 'R.dart';
import 'app.dart';
import 'db.dart';

void main() async {
  await Hive.initFlutter(R.hiveStorage);
  final settings = await Hive.openBox("Settings");
  H.box = settings;
  runApp(const CalcuPianoApp());
}
