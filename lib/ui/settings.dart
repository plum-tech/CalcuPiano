import 'package:calcupiano/design/multiplatform.dart';
import 'package:calcupiano/design/theme.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:calcupiano/theme/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:rettulf/rettulf.dart';

import '../theme/theme.dart';

part 'settings.i18n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with LockOrientationMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: I18n.title.text(),
        centerTitle: ctx.isCupertino,
      ),
      body: buildSettings(ctx),
    );
  }

  Widget buildLandscape(BuildContext ctx) {
    // TODO: Adaptive to split screen.
    return LayoutBuilder(builder: (ctx, box) {
      final padding = box.maxWidth / 5;
      return buildSettings(ctx).padH(padding);
    });
    // TODO: Add some notes around?
    return [
      SizedBox().flexible(flex: 1),
      buildSettings(ctx).flexible(flex: 5),
      SizedBox().flexible(flex: 1),
    ].row();
  }

  Widget buildSettings(BuildContext ctx) {
    return ChangeNotifierProvider(
      create: (_) => SettingsKeyTheme(),
      child: sectionCommon(ctx),
    );
  }

  Widget sectionCommon(BuildContext ctx) {
    final isDarkMode = Provider.of<CalcuPianoThemeModel>(ctx).isDarkMode;
    return SettingsKeySwitch(
      on: NotePair(Note.$5, const Icon(key: ValueKey("Light"), Icons.dark_mode)),
      off: NotePair(Note.$1, const Icon(key: ValueKey("Dark"), Icons.light_mode)),
      current: isDarkMode,
      onChanged: (newV) {
        Provider.of<CalcuPianoThemeModel>(ctx, listen: false).isDarkMode = newV;
      },
    ).sized(w: 180, h: 180);
  }
}

class SettingsKeyThemeData {
  final SoundpackProtocol soundpack;
  final double? elevation;

  const SettingsKeyThemeData({
    this.soundpack = R.classicSoundpack,
    this.elevation,
  });
}

class SettingsKeyTheme with ChangeNotifier {
  SettingsKeyThemeData _data;

  SettingsKeyThemeData get data => _data;

  SettingsKeyTheme([SettingsKeyThemeData data = const SettingsKeyThemeData()]) : _data = data;

  set data(SettingsKeyThemeData newData) {
    _data = newData;
    notifyListeners();
  }
}

class SettingsKey extends StatefulWidget {
  final SoundFileProtocol sound;
  final double? elevation;
  final Widget child;
  final VoidCallback? onTap;

  const SettingsKey({
    super.key,
    required this.sound,
    this.elevation,
    required this.child,
    this.onTap,
  });

  @override
  State<SettingsKey> createState() => _SettingsKeyState();
}

class _SettingsKeyState extends State<SettingsKey> {
  @override
  Widget build(BuildContext context) {
    final content = InkWell(
      borderRadius: context.cardBorderRadius,
      child: widget.child,
      onTap: () async {
        await Player.playSound(widget.sound);
        widget.onTap?.call();
      },
    );
    return content.inCard(
      elevation: widget.elevation,
    );
  }
}

class NotePair {
  final Note note;
  final Widget child;

  NotePair(this.note, this.child);
}

class SettingsKeySwitch extends StatefulWidget {
  final NotePair on;
  final NotePair off;
  final bool current;
  final ValueChanged<bool> onChanged;

  const SettingsKeySwitch({
    super.key,
    required this.on,
    required this.off,
    required this.current,
    required this.onChanged,
  });

  @override
  State<SettingsKeySwitch> createState() => _SettingsKeySwitchState();
}

class _SettingsKeySwitchState extends State<SettingsKeySwitch> {
  NotePair get currentNote => widget.current ? widget.on : widget.off;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<SettingsKeyTheme>(context);
    final cur = currentNote;
    return SettingsKey(
      sound: theme.data.soundpack.resolve(cur.note),
      elevation: theme.data.elevation,
      onTap: () {
        widget.onChanged(!widget.current);
      },
      child: cur.child,
    );
  }
}

class SettingsKeyMultiSwitch extends StatefulWidget {
  final List<NotePair> states;
  final int current;
  final ValueChanged<int> onChanged;

  const SettingsKeyMultiSwitch({
    super.key,
    required this.states,
    required this.current,
    required this.onChanged,
  });

  @override
  State<SettingsKeyMultiSwitch> createState() => _SettingsKeyMultiSwitchState();
}

class _SettingsKeyMultiSwitchState extends State<SettingsKeyMultiSwitch> {
  NotePair get currentNote => widget.states[widget.current];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<SettingsKeyTheme>(context);
    final cur = currentNote;
    return SettingsKey(
      sound: theme.data.soundpack.resolve(cur.note),
      elevation: theme.data.elevation,
      onTap: () {
        widget.onChanged((widget.current + 1) % widget.states.length);
      },
      child: cur.child,
    );
  }
}
