import 'package:rettulf/rettulf.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension BuildContextDesignX on BuildContext {
  bool get isMaterial {
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return false;
    }
  }

  bool get isCupertino => !isMaterial;
}

extension $BuildContextEx$ on BuildContext {
  Future<T?> show$Dialog$<T>({
    required WidgetBuilder make,
    bool dismissible = true,
  }) async {
    if (isCupertino) {
      return await showCupertinoDialog<T>(
        context: this,
        builder: make,
        barrierDismissible: dismissible,
      );
    } else {
      return await showDialog<T>(
        context: this,
        builder: make,
        barrierDismissible: dismissible,
      );
    }
  }
}

class $Button$ extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const $Button$({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isCupertino) {
      return CupertinoButton(onPressed: onPressed, child: text.text());
    } else {
      return ElevatedButton(onPressed: onPressed, child: text.text());
    }
  }
}

class $Action$ {
  final String text;
  final bool isDefault;
  final bool warning;
  final VoidCallback? onPressed;

  const $Action$({
    required this.text,
    this.onPressed,
    this.isDefault = false,
    this.warning = false,
  });
}

class $Dialog$ extends StatelessWidget {
  final String? title;
  final $Action$? primary;
  final $Action$? secondary;

  /// Highlight the title
  final bool serious;
  final WidgetBuilder make;

  const $Dialog$({
    super.key,
    this.title,
    required this.make,
    this.primary,
    this.secondary,
    this.serious = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget dialog;
    final second = secondary;
    final first = primary;
    if (context.isCupertino) {
      dialog = CupertinoAlertDialog(
        title: title?.text(style: TextStyle(fontWeight: FontWeight.w600, color: serious ? context.$red$ : null)),
        content: make(context),
        actions: [
          if (second != null)
            CupertinoDialogAction(
              isDestructiveAction: second.warning,
              isDefaultAction: second.isDefault,
              onPressed: () {
                second.onPressed?.call();
              },
              child: second.text.text(),
            ),
          if (first != null)
            CupertinoDialogAction(
              isDestructiveAction: first.warning,
              isDefaultAction: first.isDefault,
              onPressed: () {
                first.onPressed?.call();
              },
              child: primary.text.text(),
            )
        ],
      );
    } else {
      dialog = AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28.0))),
        title: title?.text(style: TextStyle(fontWeight: FontWeight.w600, color: serious ? context.$red$ : null)),
        content: make(context),
        actions: [
          if (second != null)
            TextButton(
              onPressed: () {
                second.onPressed?.call();
              },
              child: second.text.text(
                style: TextStyle(
                  color: second.warning ? context.$red$ : null,
                  fontWeight: second.isDefault ? FontWeight.w600 : null,
                ),
              ),
            ),
          if (first != null)
            TextButton(
                onPressed: () {
                  first.onPressed?.call();
                },
                child: primary.text.text(
                  style: TextStyle(
                    color: first.warning ? context.$red$ : null,
                    fontWeight: first.isDefault ? FontWeight.w600 : null,
                  ),
                ))
        ],
      );
    }
    return dialog;
  }
}

class $TextField$ extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;

  final String? labelText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmit;

  const $TextField$({
    super.key,
    this.controller,
    this.autofocus = false,
    this.placeholder,
    this.labelText,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmit,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final label = labelText;
    if (context.isCupertino) {
      return [
        if (label != null) label.text().padV(5),
        CupertinoTextField(
            controller: controller,
            autofocus: autofocus,
            placeholder: placeholder,
            textInputAction: textInputAction,
            prefix: prefixIcon,
            suffix: suffixIcon,
            readOnly: readOnly,
            enabled: enabled,
            maxLines: maxLines,
            onSubmitted: onSubmit,
            decoration: const BoxDecoration(
              color: CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.white,
                darkColor: CupertinoColors.darkBackgroundGray,
              ),
              border: _kDefaultRoundedBorder,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            style: CupertinoTheme.of(context).textTheme.textStyle),
      ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start);
    } else {
      return TextFormField(
        controller: controller,
        autofocus: autofocus,
        maxLines: maxLines,
        readOnly: readOnly,
        enabled: enabled,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          hintText: placeholder,
          icon: prefixIcon,
          labelText: labelText,
          suffixIcon: suffixIcon,
        ),
        onFieldSubmitted: onSubmit,
      );
    }
  }
}

const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0xAAA0A0A0),
  ),
  width: 1.0,
);
const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);

extension ColorEx on BuildContext {
  Color get $red$ => isCupertino ? CupertinoDynamicColor.resolve(CupertinoColors.systemRed, this) : Colors.redAccent;
}
