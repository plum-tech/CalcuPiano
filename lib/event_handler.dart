import 'package:calcupiano/events.dart';

import 'db.dart';

class EventHandler {
  EventHandler._();

  static void init() {
    eventBus.on<SoundpackChangeEvent>().listen((e) {
      H.currentSoundpackID = e.newSoundpack.id;
    });
  }
}
