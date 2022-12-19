import 'package:calcupiano/theme.dart';
import 'package:calcupiano/ui/piano.dart';
import 'package:calcupiano/ui/screen.dart';
import 'package:calcupiano/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rettulf/rettulf.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CalcuPianoApp extends StatelessWidget {
  const CalcuPianoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BrightnessModel>(
      create: (_) => BrightnessModel(),
      child: Consumer<BrightnessModel>(
        builder: (_, model, __) {
          return MaterialApp(
            theme: ThemeData.light(), // Provide light theme.
            darkTheme: ThemeData.dark(), // Provide dark theme.
            themeMode: model.resolve(), // Decides which theme to show.
            home: const CalcuPianoHomePage(),
          );
        },
      ),
    );
  }
}

class CalcuPianoHomePage extends StatefulWidget {
  const CalcuPianoHomePage({super.key});

  @override
  State<CalcuPianoHomePage> createState() => _CalcuPianoHomePageState();
}

class _CalcuPianoHomePageState extends State<CalcuPianoHomePage> {
  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? const HomePortrait() : const HomeLandscape();
  }
}

class HomePortrait extends HookWidget {
  const HomePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = useAnimationController(duration: const Duration(milliseconds: 500));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: CurveTween(curve: Curves.easeIn).animate(ctrl),
          ),
          onPressed: () {
            if (ctrl.isCompleted) {
              ctrl.reverse();
            } else {
              ctrl.forward();
            }
          },
        ),
        title: "Calcu Piano".text(),
      ),
      body: [
        const Screen().expanded(),
        // Why doesn't the constraint apply on this?
        const PianoKeyboard().expanded(),
      ]
          .column(
            mas: MainAxisSize.min,
            maa: MainAxisAlignment.center,
          )
          .safeArea(),
    );
  }
}

class HomeLandscape extends StatefulWidget {
  const HomeLandscape({super.key});

  @override
  State<HomeLandscape> createState() => _HomeLandscapeState();
}

class _Page {
  const _Page._();

  static const piano = 0;
  static const settings = 0;
}

class _HomeLandscapeState extends State<HomeLandscape> {
  int _curPage = _Page.piano;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: [
        NavigationRail(
          minWidth: 30,
          selectedIndex: _curPage,
          onDestinationSelected: (dest) {
            setState(() {
              _curPage = dest;
            });
          },
          groupAlignment: 1.0,
          labelType: NavigationRailLabelType.all,
          destinations: [
            NavigationRailDestination(
              icon: const Icon(Icons.piano_outlined),
              selectedIcon: const Icon(Icons.piano),
              label: "Piano".text(),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: "Settings".text(),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: routePage(),
        ).expanded(),
      ].row(),
    );
  }

  Widget buildBody() {
    return [
      const Screen().expanded(),
      // Why doesn't the constraint apply on this?
      const PianoKeyboard().expanded(),
    ].row(
      mas: MainAxisSize.min,
      maa: MainAxisAlignment.center,
    ).safeArea();
  }

  Widget routePage() {
    switch (_curPage) {
      case _Page.piano:
        return buildBody();
      default:
        return const Settings();
    }
  }
}
