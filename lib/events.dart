import 'package:calcupiano/foundation.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';

/// Communication among the whole hierarchy.
/// Notably, event bus will not cause rebuild by itself.
/// - It's useful to avoid rebuilding top-down.
/// - Emit data without [BuildContext], instead, the subscribers should check [State.mounted] own their own.
/// Use Cases:
/// - Changing the Soundpack should be silent, for dynamically changes when reading a sheet music.
/// - Changing settings somewhere.
final eventBus = EventBus();

/// Fire when the user pressed a Piano Key.
/// The sound should not be played in subscribers.
class KeyUserPressedEvent {
  final Note note;

  const KeyUserPressedEvent(this.note);
}

/// Fire when a Piano Key will be pressed automatically.
/// The sound and ripple effect should be played in subscribers
class KeyAutoWillPressEvent {
  final Note note;

  const KeyAutoWillPressEvent(this.note);
}

class SoundpackChangeEvent {
  final SoundpackProtocol newSoundpack;

  const SoundpackChangeEvent(this.newSoundpack);
}

class OrientationChangeEvent {
  final Orientation newOrientation;

  OrientationChangeEvent(this.newOrientation);
}
