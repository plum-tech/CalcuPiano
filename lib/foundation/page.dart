part of '../foundation.dart';

mixin LockOrientationMixin<T extends StatefulWidget> on State<T> {
  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    // Now unlock the orientation.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    // Lock the orientation to avoid navigation bar disappearing.
    if (context.isPortrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    return const _NullWidget();
  }
}

class _NullWidget extends StatelessWidget {
  const _NullWidget();

  @override
  Widget build(BuildContext context) {
    throw FlutterError(
      'Widgets that mix LockOrientationMixin into their State must '
      'call super.build() but must ignore the return value of the superclass.',
    );
  }
}
