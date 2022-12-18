import 'package:event_bus/event_bus.dart';

final eventBus = EventBus();

/// Fire when the user pressed a Piano Key.
/// The sound should not be played in subscribers.
class KeyUserPressedEvent {
  final String key;

  KeyUserPressedEvent(this.key);
}

/// Fire when a Piano Key will be pressed automatically.
/// The sound and ripple effect should be played in subscribers
class KeyAutoWillPressEvent {
  final String key;

  KeyAutoWillPressEvent(this.key);
}
