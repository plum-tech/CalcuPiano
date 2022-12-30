// ignore_for_file: non_constant_identifier_names

import 'package:calcupiano/events.dart';
import 'package:calcupiano/sheet/sheet.dart';
import 'package:flutter/foundation.dart';

final SheetInterpreter = SheetInterpreterImpl._();

class SheetInterpreterImpl with ChangeNotifier{
  SheetInterpreterImpl._();
  Sheet sheet = Sheet.empty;
  int cursor = 0;
  void init(){
    eventBus.on<KeyUserPressedEvent>().listen((e){

    });
  }
}