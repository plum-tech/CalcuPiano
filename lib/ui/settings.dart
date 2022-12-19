import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rettulf/rettulf.dart';
import 'package:settings_ui/settings_ui.dart';

import '../theme/theme.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: "Settings".text(),
      ),
      body: buildSettings(ctx),
    );
  }

  Widget buildLandscape(BuildContext ctx) {
    return buildSettings(ctx).padH(150);
    // TODO: Add some notes around?
    return [
      SizedBox().flexible(flex: 1),
      buildSettings(ctx).flexible(flex: 5),
      SizedBox().flexible(flex: 1),
    ].row();
  }

  Widget buildSettings(BuildContext ctx) {
    final isDarkMode = Provider.of<CalcuPianoThemeModel>(ctx).isDarkMode;

    return SettingsList(
      //platform: DevicePlatform.iOS,
      sections: [
        SettingsSection(
          title: Text('Common'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (value) {
                Provider.of<CalcuPianoThemeModel>(ctx, listen: false).isDarkMode = value;
              },
              initialValue: isDarkMode,
              leading: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isDarkMode
                    ? const Icon(key: ValueKey("Light"), Icons.light_mode)
                    : const Icon(key: ValueKey("Dark"), Icons.dark_mode),
              ),
              title: isDarkMode ? Text("Dark Mode") : Text("Light Mode"),
            ),
          ],
        ),
      ],
    );
  }
}
