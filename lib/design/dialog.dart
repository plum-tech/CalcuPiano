import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import 'multiplatform.dart';

typedef PickerActionWidgetBuilder = Widget Function(BuildContext context, int? selectedIndex);
typedef DualPickerActionWidgetBuilder = Widget Function(BuildContext context, int? selectedIndexA, int? selectedIndexB);

extension DialogEx on BuildContext {
  /// return: whether the button was hit
  Future<bool> showTip({
    required String title,
    required String desc,
    required String ok,
    bool highlight = false,
    bool serious = false,
  }) async {
    return showAnyTip(
      title: title,
      make: (_) => desc.text(style: const TextStyle()),
      ok: ok,
      highlight: false,
      serious: serious,
    );
  }

  Future<bool> showAnyTip({
    required String title,
    required WidgetBuilder make,
    required String ok,
    bool highlight = false,
    bool serious = false,
  }) async {
    final dynamic confirm = await show$Dialog$(
      make: (ctx) => $Dialog$(
          title: title,
          serious: serious,
          make: make,
          primary: $Action$(
            warning: highlight,
            text: ok,
            onPressed: () {
              ctx.navigator.pop(true);
            },
          )),
    );
    return confirm == true;
  }

  Future<bool?> showRequest({
    required String title,
    required String desc,
    required String yes,
    required String no,
    bool highlight = false,
    bool serious = false,
  }) async {
    return await showAnyRequest(
      title: title,
      make: (_) => desc.text(style: const TextStyle()),
      yes: yes,
      no: no,
      highlight: highlight,
      serious: serious,
    );
  }

  Future<bool?> showAnyRequest({
    required String title,
    required WidgetBuilder make,
    required String yes,
    required String no,
    bool highlight = false,
    bool serious = false,
  }) async {
    return await show$Dialog$(
      make: (ctx) => $Dialog$(
        title: title,
        serious: serious,
        make: make,
        primary: $Action$(
          warning: highlight,
          text: yes,
          onPressed: () {
            ctx.navigator.pop(true);
          },
        ),
        secondary: $Action$(
          text: no,
          onPressed: () {
            ctx.navigator.pop(false);
          },
        ),
      ),
    );
  }
}
