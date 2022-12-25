import 'package:calcupiano/events.dart';
import 'package:calcupiano/foundation.dart';

class EventHandler {
  EventHandler._();

  static void init() {
    eventBus.on<SoundpackChangeEvent>().listen((e) async {
      H.currentSoundpackID = e.newSoundpack.id;
    });
  }
}
