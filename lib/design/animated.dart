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
