import 'package:calcupiano/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rettulf/rettulf.dart';
import 'package:settings_ui/settings_ui.dart';

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
    return buildSettings(ctx);
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
    final isDarkMode = Provider.of<BrightnessModel>(ctx).isDarkMode;

    return SettingsList(
      //platform: DevicePlatform.iOS,
      sections: [
        SettingsSection(
          title: Text('Common'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (value) {
                Provider.of<BrightnessModel>(ctx, listen: false).isDarkMode = value;
              },
              initialValue: isDarkMode,
              leading: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              title: Text("Dark Mode"),
            ),
          ],
        ),
      ],
    );
  }
}
