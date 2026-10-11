import 'package:flutter/material.dart';

/// App-wide SnackBar defaults: never sticky when an action is present.
abstract final class VireoSnackBar {
  static const duration = Duration(seconds: 3);

  static void show(
    BuildContext context, {
    required Widget content,
    SnackBarAction? action,
    Duration duration = duration,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: content,
          action: action,
          duration: duration,
          persist: false,
        ),
      );
  }

  static void showText(
    BuildContext context,
    String text, {
    SnackBarAction? action,
    Duration duration = duration,
  }) {
    show(context, content: Text(text), action: action, duration: duration);
  }
}
