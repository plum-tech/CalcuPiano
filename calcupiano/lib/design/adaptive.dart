import 'package:flutter/widgets.dart';

// Thanks to https://github.com/mohammadtaherri/flutter_flexible_ui
/// It also stands for split screen.
// Portrait
const Size kDefaultMinWatchPortraitSize = Size(300, 480);
const Size kDefaultMinHeadsetPortraitSize = Size(400, 600);
const Size kDefaultMinTabletPortraitSize = Size(720, 800);

//Landscape
const Size kDefaultMinWatchLandscapeSize = Size(360, 300);
const Size kDefaultMinHeadsetLandscapeSize = Size(600, 400);
const Size kDefaultMinTabletLandscapeSize = Size(1024, 720);

class BreakpointData {
  final Size minWatchPortraitSize;

  final Size minWatchLandscapeSize;

  final Size minHeadsetPortraitSize;

  final Size minHeadsetLandscapeSize;

  final Size minTabletPortraitSize;

  final Size minTabletLandscapeSize;

  const BreakpointData({
    this.minWatchPortraitSize = kDefaultMinWatchPortraitSize,
    this.minWatchLandscapeSize = kDefaultMinWatchLandscapeSize,
    this.minHeadsetPortraitSize = kDefaultMinHeadsetPortraitSize,
    this.minHeadsetLandscapeSize = kDefaultMinHeadsetLandscapeSize,
    this.minTabletPortraitSize = kDefaultMinTabletPortraitSize,
    this.minTabletLandscapeSize = kDefaultMinTabletLandscapeSize,
  });

  ScreenType getScreenType(Size size, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      if (size.width <= minWatchPortraitSize.width || size.height <= minWatchPortraitSize.height) {
        return ScreenType.watchPortrait;
      }
      if (size.width <= minHeadsetPortraitSize.width || size.height <= minHeadsetPortraitSize.height) {
        return ScreenType.headsetPortrait;
      }
      if (size.width <= minTabletPortraitSize.width || size.height <= minTabletPortraitSize.height) {
        return ScreenType.tabletPortrait;
      }
      return ScreenType.desktopPortrait;
    } else {
      if (size.width <= minWatchLandscapeSize.width || size.height <= minWatchLandscapeSize.height) {
        return ScreenType.watchLandscape;
      }
      if (size.width <= minHeadsetPortraitSize.width || size.height <= minHeadsetPortraitSize.height) {
        return ScreenType.headsetLandscape;
      }
      if (size.width <= minTabletPortraitSize.width || size.height <= minTabletPortraitSize.height) {
        return ScreenType.tabletLandscape;
      }
      return ScreenType.desktopLandscape;
    }
  }

  BreakpointData copyWith({
    Size? minWatchPortraitSize,
    Size? minWatchLandscapeSize,
    Size? minHeadsetPortraitSize,
    Size? minHeadsetLandscapeSize,
    Size? minTabletPortraitSize,
    Size? minTabletLandscapeSize,
  }) =>
      BreakpointData(
        minWatchPortraitSize: minWatchPortraitSize ?? this.minWatchPortraitSize,
        minWatchLandscapeSize: minWatchLandscapeSize ?? this.minWatchLandscapeSize,
        minHeadsetPortraitSize: minHeadsetPortraitSize ?? this.minHeadsetPortraitSize,
        minHeadsetLandscapeSize: minHeadsetLandscapeSize ?? this.minHeadsetLandscapeSize,
        minTabletPortraitSize: minTabletPortraitSize ?? this.minTabletPortraitSize,
        minTabletLandscapeSize: minTabletLandscapeSize ?? this.minTabletLandscapeSize,
      );

  @override
  bool operator ==(Object other) {
    if (other is! BreakpointData) return false;
    if (identical(this, other)) return true;

    if (minWatchPortraitSize != other.minWatchPortraitSize) return false;
    if (minWatchLandscapeSize != other.minWatchLandscapeSize) return false;
    if (minHeadsetPortraitSize != other.minHeadsetPortraitSize) return false;
    if (minHeadsetLandscapeSize != other.minHeadsetLandscapeSize) return false;
    if (minTabletPortraitSize != other.minTabletPortraitSize) return false;
    if (minTabletLandscapeSize != other.minTabletLandscapeSize) return false;

    return true;
  }

  @override
  int get hashCode =>
      minWatchPortraitSize.hashCode ^
      minWatchLandscapeSize.hashCode ^
      minHeadsetPortraitSize.hashCode ^
      minHeadsetLandscapeSize.hashCode ^
      minTabletPortraitSize.hashCode ^
      minTabletLandscapeSize.hashCode;
}

class Breakpoint extends InheritedWidget {
  const Breakpoint({
    Key? key,
    this.breakpointData = const BreakpointData(),
    required Widget child,
  }) : super(key: key, child: child);
  final BreakpointData breakpointData;

  @override
  bool updateShouldNotify(covariant Breakpoint oldWidget) {
    return oldWidget.breakpointData != breakpointData;
  }

  /// The [breakPointData] from the closest [Breakpoint] instance that encloses the given
  /// context.
  static BreakpointData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Breakpoint>()?.breakpointData;
  }
}

extension BreakpointX on BuildContext {
  /// Get the current [BreakpointData]. This is a shortcut for `Breakpoint.of(context)`.
  BreakpointData? get breakpoint => Breakpoint.of(this);
}

typedef AdaptiveWidgetBuilder = Widget Function(BuildContext context, AdaptiveScreen screen);

class AdaptiveBuilder extends StatelessWidget {
  const AdaptiveBuilder({
    super.key,
    required this.defaultBuilder,
    this.breakpointData,
    this.layoutDelegate,
  });

  final AdaptiveWidgetBuilder defaultBuilder;
  final AdaptiveLayoutDelegate? layoutDelegate;
  final BreakpointData? breakpointData;

  @override
  Widget build(BuildContext context) {
    AdaptiveScreen screen = AdaptiveScreen(
      mediaQueryData: MediaQuery.of(context),
      breakpointData: breakpointData ?? Breakpoint.of(context) ?? const BreakpointData(),
    );

    return layoutDelegate?.getBuilder(screen)?.call(context, screen) ?? defaultBuilder.call(context, screen);
  }
}

abstract class AdaptiveLayoutDelegate {
  @protected
  AdaptiveWidgetBuilder? getBuilder(AdaptiveScreen screen);
}

class AdaptiveLayoutDelegateWithScreenType implements AdaptiveLayoutDelegate {
  const AdaptiveLayoutDelegateWithScreenType({
    this.defaultBuilder,
    this.watchPortrait,
    this.watchLandscape,
    this.headsetPortrait,
    this.headsetLandscape,
    this.tabletPortrait,
    this.tabletLandscape,
    this.desktopPortrait,
    this.desktopLandscape,
  });

  final AdaptiveWidgetBuilder? defaultBuilder;
  final AdaptiveWidgetBuilder? watchPortrait;
  final AdaptiveWidgetBuilder? watchLandscape;
  final AdaptiveWidgetBuilder? headsetPortrait;
  final AdaptiveWidgetBuilder? headsetLandscape;
  final AdaptiveWidgetBuilder? tabletPortrait;
  final AdaptiveWidgetBuilder? tabletLandscape;
  final AdaptiveWidgetBuilder? desktopPortrait;
  final AdaptiveWidgetBuilder? desktopLandscape;

  @override
  @protected
  AdaptiveWidgetBuilder? getBuilder(AdaptiveScreen screen) {
    switch (screen.screenType) {
      case ScreenType.watchPortrait:
        return watchPortrait;
      case ScreenType.watchLandscape:
        return watchLandscape;
      case ScreenType.headsetPortrait:
        return headsetPortrait;
      case ScreenType.headsetLandscape:
        return headsetLandscape;
      case ScreenType.tabletPortrait:
        return tabletPortrait;
      case ScreenType.tabletLandscape:
        return tabletLandscape;
      case ScreenType.desktopPortrait:
        return desktopPortrait;
      case ScreenType.desktopLandscape:
        return desktopLandscape;
    }
  }
}

class AdaptiveLayoutDelegateWithSingleBuilder implements AdaptiveLayoutDelegate {
  const AdaptiveLayoutDelegateWithSingleBuilder(this.builder);

  final AdaptiveWidgetBuilder builder;

  @override
  AdaptiveWidgetBuilder? getBuilder(AdaptiveScreen screen) {
    return builder;
  }
}

class AdaptiveScreen {
  final MediaQueryData mediaQueryData;
  final BreakpointData breakpointData;
  late final ScreenType screenType;

  AdaptiveScreen({
    required this.mediaQueryData,
    required this.breakpointData,
  }) {
    final size = mediaQueryData.size;
    final orientation = mediaQueryData.orientation;
    screenType = breakpointData.getScreenType(size, orientation);
  }

  factory AdaptiveScreen.fromContext(BuildContext context) => AdaptiveScreen(
        mediaQueryData: MediaQuery.of(context),
        breakpointData: Breakpoint.of(context) ?? const BreakpointData(),
      );

  factory AdaptiveScreen.fromWindow() {
    WidgetsFlutterBinding.ensureInitialized();
    return AdaptiveScreen(
      mediaQueryData: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      breakpointData: const BreakpointData(),
    );
  }
}

enum ScreenType {
  watchPortrait,
  watchLandscape,
  headsetPortrait,
  headsetLandscape,
  tabletPortrait,
  tabletLandscape,
  desktopPortrait,
  desktopLandscape;
}
