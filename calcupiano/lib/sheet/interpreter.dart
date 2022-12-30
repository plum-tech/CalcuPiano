// ignore_for_file: non_constant_identifier_names

import 'package:calcupiano/sheet/sheet.dart';
import 'package:flutter/foundation.dart';

final SheetInterpreter = SheetInterpreterImpl();

class SheetInterpreterImpl with ChangeNotifier{
  Sheet sheet = Sheet.empty;
  int cursor = 0;
}