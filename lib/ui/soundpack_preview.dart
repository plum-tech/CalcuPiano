import 'package:calcupiano/design/overlay.dart';
import 'package:calcupiano/events.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:calcupiano/theme/keyboard.dart';
import 'package:calcupiano/ui/piano.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rettulf/rettulf.dart';

class SoundpackPreviewWindow extends StatefulWidget {
  final SoundpackProtocol soundpack;
  final double aspectRatio;
  final CloseableProtocol? closeable;

  const SoundpackPreviewWindow(
    this.soundpack, {
    super.key,
    this.closeable,
    this.aspectRatio = R.soundpackWindowAspectRatio,
  });

  @override
  State<SoundpackPreviewWindow> createState() => _SoundpackPreviewWindowState();
}

class _SoundpackPreviewWindowState extends State<SoundpackPreviewWindow> {
  SoundpackProtocol get soundpack => widget.soundpack;
  var _x = 0.0;
  var _y = 0.0;
  final _mainBodyKey = GlobalKey();
  static var scaleDelta = 0.0;
  static const scaleRange = 150;

  static double get scaleDeltaProgress => clampDouble(scaleDelta / scaleRange, 0.0, 1.0);

  static set scaleDeltaProgress(double newV) => scaleDelta = newV * scaleRange;
  var isResizing = false;

  // Hide the first frame to avoid position flash
  var opacity = 0.0;

  @override
  void initState() {
    super.initState();
    eventBus.on<OrientationChangeEvent>().listen((event) {
      setState(() {
        scaleDelta = 0.0;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final ctx = _mainBodyKey.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject();
        if (box is RenderBox) {
          final childSize = box.size;
          final selfSize = context.mediaQuery.size;
          setState(() {
            _x = (selfSize.width - childSize.width) / 2;
            _y = (selfSize.height - childSize.height) / 2;
            opacity = 1.0;
          });
        }
      }
    });
  }

  Size calcuBestSize(BuildContext ctx) {
    final full = ctx.mediaQuery.size;
    if (ctx.isPortrait) {
      // on Portrait mode, the preview window is based on width.
      final width = full.width * 0.8;
      final height = width / widget.aspectRatio + scaleDelta;
      return Size(width, height);
    } else {
      // on Landscape mode, the preview window is based on height.
      final height = full.height * 0.8 + scaleDelta;
      final width = height * widget.aspectRatio;
      return Size(width, height);
    }
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = calcuBestSize(context);
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 300),
      child: [
        Positioned(
            key: _mainBodyKey,
            left: _x,
            top: _y,
            child: [
              Listener(
                child: buildWindowHead(context),
                onPointerMove: (d) {
                  if (!isResizing) {
                    setState(() {
                      _x += d.delta.dx;
                      _y += d.delta.dy;
                    });
                  }
                },
              ).sized(w: windowSize.width),
              buildKeyboard(windowSize),
            ].column().inCard()),
      ].stack().safeArea(),
    );
  }

  Widget buildTitle(BuildContext ctx) {
    final Widget res;
    if (isResizing) {
      res = Slider(
        value: scaleDeltaProgress,
        onChanged: (newV) {
          setState(() {
            scaleDeltaProgress = newV;
          });
        },
      );
    } else {
      final style = ctx.textTheme.headlineSmall;
      res = [
        soundpack.displayName
            .text(style: style, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1)
            .padSymmetric(h: 10, v: 10)
            .align(at: Alignment.center),
      ].stack().inCard(elevation: 2);
    }
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      child: res,
    );
  }

  Widget buildWindowHead(BuildContext ctx) {
    final closeable = widget.closeable;
    return [
      IconButton(
        onPressed: () {
          setState(() {
            isResizing = !isResizing;
          });
        },
        icon: const Icon(Icons.open_in_full_rounded),
      ),
      buildTitle(ctx).expanded(),
      if (closeable != null)
        IconButton(
            onPressed: () {
              closeable.closeWindow();
            },
            icon: const Icon(Icons.close)),
    ].row();
  }

  Widget buildKeyboard(Size windowSize) {
    return ChangeNotifierProvider(
      create: (_) => KeyboardThemeModel(const KeyboardThemeData(elevation: 5)),
      child: PianoKeyboard(fixedSoundpack: soundpack).sizedIn(windowSize),
    );
  }
}
