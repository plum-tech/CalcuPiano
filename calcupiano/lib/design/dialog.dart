import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rettulf/rettulf.dart';

import 'multiplatform.dart';

extension DialogEx on BuildContext {
  /// return: whether the button was hit
  Future<bool> showTip({
    required String title,
    required String desc,
    required String ok,
    bool highlight = false,
    bool serious = false,
    bool dismissible = true,
  }) async {
    return showAnyTip(
      dismissible: dismissible,
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
    bool dismissible = true,
  }) async {
    final dynamic confirm = await show$Dialog$(
      dismissible: dismissible,
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
    bool dismissible = true,
  }) async {
    return await showAnyRequest(
      dismissible: dismissible,
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
    bool dismissible = true,
  }) async {
    return await show$Dialog$(
      dismissible: dismissible,
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

  Future<void> showWaiting({
    required Future<void> until,
    required String title,
    bool serious = false,
  }) async {
    bool isWaiting = true;
    show$Dialog$(
      dismissible: false,
      make: (ctx) => WillPopScope(
        onWillPop: () async {
          return !isWaiting;
        },
        child: $Dialog$(
          title: title,
          serious: serious,
          make: (_) => LoadingAnimationWidget.beat(
            color: theme.primaryColor,
            size: 64,
          ).padAll(24),
        ),
      ),
    );
    await until;
    isWaiting = false;
    navigator.pop();
    return;
  }
}
