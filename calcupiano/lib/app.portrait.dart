part of 'app.dart';

class HomePortrait extends StatefulWidget {
  const HomePortrait({super.key});

  @override
  State<StatefulWidget> createState() => _HomePortraitState();
}

class _HomePortraitState extends State<HomePortrait> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final AnimationController ctrl;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(covariant HomePortrait oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isOpen = _scaffoldKey.currentState?.isDrawerOpen;
    if (isOpen != null && isOpen != _isDrawerOpen) {
      setState(() {
        _isDrawerOpen = isOpen;
      });
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer(BuildContext ctx) {
    ctx.navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final fullSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: CalcuPianoDrawer(
        onCloseDrawer: () {
          _closeDrawer(context);
        },
      ),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          ctrl.forward();
        } else {
          ctrl.reverse();
        }
        if (isOpened != _isDrawerOpen) {
          setState(() {
            _isDrawerOpen = isOpened;
          });
        }
      },
      body: AnimatedScale(
        scale: _isDrawerOpen ? 0.96 : 1,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 1000),
        child: buildMainArea(context, ctrl, _isDrawerOpen, fullSize),
      ),
    );
  }

  Widget buildMainArea(BuildContext ctx, AnimationController ctrl, bool isDrawerOpen, Size fullSize) {
    if (kIsWeb) {
      return buildMain(context, ctrl, _isDrawerOpen);
    } else {
      // ImplicitlyAnimatedWidget doesn't work on Flutter Web
      return [
        buildMain(context, ctrl, _isDrawerOpen),
        AnimatedBlur(
          blur: _isDrawerOpen ? 3 : 0,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 1000),
          child: SizedBox(
            width: fullSize.width,
            height: fullSize.height,
          ),
        ),
      ].stack();
    }
  }

  Widget buildMain(BuildContext ctx, AnimationController ctrl, bool isDrawerOpen) {
    return Scaffold(
      body: [
        IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: CurveTween(curve: Curves.easeIn).animate(ctrl),
          ),
          onPressed: () {
            if (ctrl.isCompleted) {
              ctrl.reverse();
            } else {
              ctrl.forward().then((value) {
                _openDrawer();
              });
            }
          },
        ).safeArea(),
        [
          const SheetScreen().expanded(),
          // Why doesn't the constraint apply on this?
          const PianoKeyboard().expanded(),
        ]
            .column(
              mas: MainAxisSize.min,
              maa: MainAxisAlignment.center,
            )
            .safeArea()
      ].stack(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    ctrl.dispose();
  }
}

class CalcuPianoDrawer extends HookWidget {
  final VoidCallback? onCloseDrawer;

  const CalcuPianoDrawer({super.key, this.onCloseDrawer});

  void closeDrawer() {
    onCloseDrawer?.call();
  }

  @override
  Widget build(BuildContext context) {
    final packageInfo = R.packageInfo;
    final version = packageInfo != null ? "v ${packageInfo.version}" : "v ${R.version}";
    return SizedBox(
      width: 220,
      child: Drawer(
        child: [
          Column(
            children: [
              const DrawerHeader(child: SizedBox()).flexible(flex: 1),
              ListTile(
                leading: const Icon(Icons.music_note),
                title: I18n.soundpack.text(),
                trailing: const Icon(Icons.navigate_next),
                onTap: () {
                  closeDrawer();
                  context.navigator.push(MaterialPageRoute(builder: (ctx) => const SoundpackPage()));
                },
              )
            ],
          ).expanded(),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: I18n.settings.text(),
            onTap: () {
              closeDrawer();
              context.navigator.push(MaterialPageRoute(builder: (ctx) => const SettingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: version.text(),
          ),
        ].column(),
      ),
    );
  }
}
