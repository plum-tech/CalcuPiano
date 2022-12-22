import 'package:calcupiano/design/overlay.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/theme/keyboard.dart';
import 'package:calcupiano/ui/piano.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rettulf/rettulf.dart';

class SoundpackPreviewTop extends StatefulWidget {
  final SoundpackProtocol soundpack;
  final CloseableProtocol? closeable;

  const SoundpackPreviewTop(this.soundpack, {super.key, this.closeable});

  @override
  State<SoundpackPreviewTop> createState() => _SoundpackPreviewTopState();
}

class _SoundpackPreviewTopState extends State<SoundpackPreviewTop> {
  SoundpackProtocol get soundpack => widget.soundpack;
  var _x = 0.0;
  var _y = 0.0;
  final _mainBodyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
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
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return [
      Positioned(
          key: _mainBodyKey,
          left: _x,
          top: _y,
          child: [
            Listener(
              child: buildWindowHead(context),
              onPointerMove: (d) {
                setState(() {
                  _x += d.delta.dx;
                  _y += d.delta.dy;
                });
              },
            ).sized(w: 350),
            buildKeyboard(),
          ].column().inCard()),
    ].stack();
  }

  Widget buildWindowHead(BuildContext ctx) {
    final style = ctx.textTheme.headlineSmall;
    final closeable = widget.closeable;
    return [
      soundpack.displayName.text(style: style, textAlign: TextAlign.center).padOnly(t: 10).align(at: Alignment.center),
      if (closeable != null)
        IconButton(
                onPressed: () {
                  closeable.closeWindow();
                },
                icon: Icon(Icons.close))
            .align(at: Alignment.centerRight),
    ].stack().inCard(elevation: 2);
  }

  Widget buildKeyboard() {
    return ChangeNotifierProvider(
      create: (_) => KeyboardThemeModel(KeyboardThemeData(elevation: 5)),
      child: PianoKeyboard(fixedSoundpack: soundpack).sized(w: 350, h: 400),
    );
  }
}
