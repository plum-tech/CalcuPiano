import 'package:calcupiano/design/multiplatform.dart';
import 'package:calcupiano/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rettulf/rettulf.dart';
import 'package:settings_ui/settings_ui.dart';

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
    final isDarkMode = Provider.of<CalcuPianoThemeModel>(ctx).isDarkMode;
    final theme = SettingsThemeData(settingsListBackground: ctx.theme.canvasColor);
    return SettingsList(
      lightTheme: theme,
      darkTheme: theme,
      sections: [
        SettingsSection(
          title: I18n.common.title.text(),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (value) {
                Provider.of<CalcuPianoThemeModel>(ctx, listen: false).isDarkMode = value;
              },
              initialValue: isDarkMode,
              leading: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isDarkMode
                    ? const Icon(key: ValueKey("Light"), Icons.dark_mode)
                    : const Icon(key: ValueKey("Dark"), Icons.light_mode),
              ),
              title: isDarkMode ? I18n.common.darkMode.text() : I18n.common.lightMode.text(),
            ),
          ],
        ),
      ],
    );
  }
}
