import 'package:calcupiano/ui/piano.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class CalcuPianoApp extends StatelessWidget {
  const CalcuPianoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalcuPianoHomePage(),
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

class HomePortrait extends StatefulWidget {
  const HomePortrait({super.key});

  @override
  State<HomePortrait> createState() => _HomePortraitState();
}

class _HomePortraitState extends State<HomePortrait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Calcu Piano".text(),
      ),
      body: [
        const Text(
          'You have pushed the button this many times:',
        ).expanded(),
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
        buildBody().expanded(),
      ].row().safeArea(),
    );
  }

  Widget buildBody() {
    return [
      const Text(
        'You have pushed the button this many times:',
      ).expanded(),
      // Why doesn't the constraint apply on this?
      const PianoKeyboard().expanded(),
    ].row(
      mas: MainAxisSize.min,
      maa: MainAxisAlignment.center,
    );
  }
}
