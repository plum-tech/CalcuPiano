import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:calcupiano/db.dart';
import 'package:calcupiano/design/adaptive.dart';
import 'package:calcupiano/design/animated.dart';
import 'package:calcupiano/design/overlay.dart';
import 'package:calcupiano/r.dart';
import 'package:calcupiano/theme/theme.dart';
import 'package:calcupiano/ui/about.dart';
import 'package:calcupiano/ui/piano.dart';
import 'package:calcupiano/ui/sheet_screen.dart';
import 'package:calcupiano/ui/settings.dart';
import 'package:calcupiano/ui/soundpack.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rettulf/rettulf.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'app.i18n.dart';

part 'app.portrait.dart';

part 'app.landscape.dart';

class CalcuPianoApp extends StatefulWidget {
  const CalcuPianoApp({super.key});

  @override
  State<StatefulWidget> createState() => CalcuPianoAppState();
}

class CalcuPianoAppState extends State<CalcuPianoApp> {
  bool? isDarkModeInitial;

  @override
  void initState() {
    super.initState();
    isDarkModeInitial = H.isDarkMode;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return wrapWithService(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CalcuPianoThemeModel>(
              create: (_) => CalcuPianoThemeModel(CalcuPianoThemeData.isDarkMode(isDarkModeInitial))),
        ],
        child: Consumer<CalcuPianoThemeModel>(
          builder: (_, model, __) {
            return Breakpoint(
              child: MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: bakeTheme(context, ThemeData.light(), model.data),
                darkTheme: bakeTheme(context, ThemeData.dark(), model.data),
                themeMode: model.resolveThemeMode(),
                home: const CalcuPianoHomePage(),
              ),
            );
          },
        ),
      ),
    );
  }

  ThemeData bakeTheme(BuildContext ctx, ThemeData raw, CalcuPianoThemeData theme) {
    return raw.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
      ),
      cardTheme: raw.cardTheme.copyWith(
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent), //the outline color
            borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      splashColor: theme.enableRipple ? null : Colors.transparent,
      highlightColor: theme.enableRipple ? null : Colors.transparent,
      useMaterial3: true,
      // TODO: Temporarily debug Visual effects on iOS.
      //   platform: TargetPlatform.iOS,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }

  Widget wrapWithService(Widget mainBody) {
    return wrapWithScreenUtil(
      wrapWithTop(
        mainBody,
      ),
    );
  }

  Widget wrapWithTop(Widget mainBody) {
    return Top.global(child: mainBody);
  }

  Widget wrapWithScreenUtil(Widget mainBody) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return mainBody;
        });
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
    return AdaptiveBuilder(
      defaultBuilder: (ctx, screen) {
        return const Scaffold(body: PianoKeyboard());
      },
      layoutDelegate: AdaptiveLayoutDelegateWithScreenType(
        watchPortrait: (ctx, screen) {
          return const Scaffold(body: PianoKeyboard());
        },
        watchLandscape: (ctx, screen) {
          return const Scaffold(body: PianoKeyboard());
        },
        headsetPortrait: (ctx, screen) {
          return const HomePortrait();
        },
        headsetLandscape: (ctx, screen) {
          return const HomeTabletLandscape();
        },
        tabletPortrait: (ctx, screen) {
          return const HomePortrait();
        },
        tabletLandscape: (ctx, screen) {
          return const HomeTabletLandscape();
        },
        desktopPortrait: (ctx, screen) {
          return const HomePortrait();
        },
        desktopLandscape: (ctx, screen) {
          return const HomeDesktopLandscape();
        },
      ),
    );
  }
}
