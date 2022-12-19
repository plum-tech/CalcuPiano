import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

import 'R.dart';
import 'app.dart';

void main() async {
  await Hive.initFlutter(R.hiveStorage);
  runApp(const CalcuPianoApp());
}
