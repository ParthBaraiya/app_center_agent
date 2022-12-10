import 'package:app_center_agent/values/constants.dart';
import 'package:flutter/material.dart';

extension ContextUtilityExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ScaffoldFeatureController showSnackBar({
    required String message,
    Duration duration = AppConstants.snackBarDuration,
  }) {
    return (ScaffoldMessenger.of(this)..hideCurrentSnackBar()).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }
}

extension ListExtension<T> on List<T> {
  bool testAll(bool Function(T, int) predicate) {
    var pass = true;
    var count = 0;

    for (final item in this) {
      pass &= predicate(item, count++);
    }
    return pass;
  }
}

extension ColorExtension on Color {
  String get codeString {
    return '${red.toRadixString(16)}${green.toRadixString(16)}${blue.toRadixString(16)}';
  }
}
