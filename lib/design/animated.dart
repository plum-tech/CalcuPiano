import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Thanks to [Yasin Arık](https://github.com/yasinarik/flutter_pro_animated_blur).
class AnimatedBlur extends ImplicitlyAnimatedWidget {
  final double blur;
  final Widget? child;

  const AnimatedBlur({
    super.key,
    required this.blur,
    required super.duration,
    super.curve = Curves.linear,
    super.onEnd,
    this.child,
  });

  @override
  AnimatedWidgetBaseState<AnimatedBlur> createState() => _AnimatedBlurState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<double>('blur', blur));
  }
}

class _AnimatedBlurState extends AnimatedWidgetBaseState<AnimatedBlur> {
  Tween<double>? _blurTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _blurTween =
        visitor(_blurTween, widget.blur, (dynamic value) => Tween<double>(begin: value as double)) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: _blurTween?.evaluate(animation) ?? 0,
        sigmaY: _blurTween?.evaluate(animation) ?? 0,
      ),
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<Tween<double>>('blur', _blurTween, defaultValue: null));
  }
}
extension LiveListAnimationX on Widget {
  Widget aliveWith(
      Animation<double> animation,
      ) =>
      // For example wrap with fade transition
  FadeTransition(
    opacity: CurveTween(
      curve: Curves.fastLinearToSlowEaseIn,
    ).animate(animation),
    // And slide transition
    child: SlideTransition(
      position: CurveOffset(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
        curve: Curves.fastLinearToSlowEaseIn,
      ).animate(animation),
      // Paste you Widget
      child: this,
    ),
  );
}
class CurveOffset extends Animatable<Offset> {
  final Offset begin;
  final Offset end;

  /// Creates a curve tween.
  ///
  /// The [curve] argument must not be null.
  CurveOffset({required this.begin, required this.end, required this.curve});

  /// The curve to use when transforming the value of the animation.
  final Curve curve;

  @override
  Offset transform(double t) {
    return Offset(
      curve.transform(t) * (end.dx - begin.dx) + begin.dx,
      curve.transform(t) * (end.dy - begin.dy) + begin.dy,
    );
  }

  @override
  String toString() => 'CurveTweenOffset(curve: $curve)';
}
