import 'dart:math';

import 'package:calcupiano/design/multiplatform.dart';
import 'package:calcupiano/design/theme.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: I18n.title.text(),
        centerTitle: context.isCupertino,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext ctx) {
    return ChangeNotifierProvider(
      create: (_) => SettingsKeyTheme(),
      child: buildSettings(ctx),
    );
  }

  Widget buildSettings(BuildContext ctx) {
    return SettingsAdaptivePanel(groups: [
      SettingsGroup(
          name: I18n.appearance.name,
          builder: (ctx) {
            return [
              brightness(ctx),
              language(ctx),
            ];
          })
    ]);
  }

  Widget brightness(BuildContext ctx) {
    final isDarkMode = Provider.of<CalcuPianoThemeModel>(ctx).isDarkMode;
    final toggle = SettingsKeySwitch(
      on: NotePair(Note.$5, const Icon(Icons.dark_mode)),
      off: NotePair(Note.$1, const Icon(Icons.light_mode)),
      current: isDarkMode,
      onChanged: (newV) {
        Provider.of<CalcuPianoThemeModel>(ctx, listen: false).isDarkMode = newV;
      },
    ).sized(w: 80);
    return ListTile(
      title: I18n.appearance.brightness.text(style: ctx.textTheme.headlineSmall),
      subtitle: I18n.appearance.themeMode(isDarkMode).text(),
      trailing: toggle,
    );
  }

  Widget language(BuildContext ctx) {
    const icon = Icon(Icons.language);
    final locales = ctx.supportedLocales;
    final curLocale = ctx.locale;
    final curIndex = max(0, locales.indexOf(curLocale));
    final toggle = SettingsKeyMultiSwitch(
      states: Note.loopSequence(locales.length).map((note) => NotePair(note, icon)).toList(),
      current: curIndex,
      onChanged: (selectedIndex) {
        ctx.setLocale(ctx.supportedLocales[selectedIndex]);
      },
    ).sized(w: 80);
    return ListTile(
      title: I18n.appearance.language.text(style: ctx.textTheme.headlineSmall),
      subtitle: curLocale.toString().text(),
      trailing: toggle,
    );
  }
}

class SettingsAdaptivePanel extends StatelessWidget {
  final List<SettingsGroup> groups;

  const SettingsAdaptivePanel({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, box) {
      if (box.minWidth < 600) {
        return SettingsPanelSmall(groups: groups);
      } else {
        return SettingsPanelLarge(groups: groups);
      }
    });
  }
}

class SettingsPanelSmall extends StatefulWidget {
  final List<SettingsGroup> groups;

  const SettingsPanelSmall({
    super.key,
    required this.groups,
  });

  @override
  State<SettingsPanelSmall> createState() => _SettingsPanelSmallState();
}

class _SettingsPanelSmallState extends State<SettingsPanelSmall> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const RangeMaintainingScrollPhysics(),
      itemCount: widget.groups.length,
      itemBuilder: (ctx, i) => buildGroup(ctx, widget.groups[i]),
    );
  }

  Widget buildGroup(BuildContext ctx, SettingsGroup group) {
    final titleStyle = ctx.textTheme.titleLarge;
    final list = <Widget>[];
    list.add(group.name.text(style: titleStyle?.copyWith(color: titleStyle.color?.withOpacity(0.8))).padAll(5));
    final tiles = group.builder(ctx);
    list.addAll(tiles);
    return list.column();
  }
}

class SettingsPanelLarge extends StatefulWidget {
  final List<SettingsGroup> groups;

  const SettingsPanelLarge({
    super.key,
    required this.groups,
  });

  @override
  State<SettingsPanelLarge> createState() => _SettingsPanelLargeState();
}

class _SettingsPanelLargeState extends State<SettingsPanelLarge> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

typedef GroupBuilder = List<Widget> Function(BuildContext ctx);

class SettingsGroup {
  final String name;
  final GroupBuilder builder;

  SettingsGroup({
    required this.name,
    required this.builder,
  });
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
      child: cur.child.center(),
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
      child: cur.child.center(),
    );
  }
}
