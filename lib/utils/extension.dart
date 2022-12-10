import 'dart:math' as math;

import 'package:app_center_agent/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';

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

extension DateTimeFormatExtension on DateTime {
  String get formatted => DateFormat('dd MMM yyyy').format(this);

  DateTime get withoutTime => DateTime(year, month, day);
}

extension StringExtension on String {
  String get initials {
    if (isEmpty) return '';

    final parts = split(' ');

    return parts
        .getRange(0, math.min(2, parts.length))
        .map((e) => e.isEmpty ? '' : e[0].toUpperCase())
        .join();
  }
}

extension IterableExtensions<T> on Iterable<T> {
  T? firstWhereOrNull(TestPredicate<T> test, {T Function()? orElse}) {
    try {
      return firstWhere(test, orElse: orElse);
    } catch (e) {
      return null;
    }
  }
}

extension BooleanExtension on bool {
  String get yesOrNo => this ? 'Yes' : 'No';
  int get asInteger => this ? 1 : 0;
}

extension DownloadTaskStatusExtension on DownloadTaskStatus {
  Color get color {
    switch (this) {
      case DownloadTaskStatus.undefined:
        return Colors.black;
      case DownloadTaskStatus.enqueued:
        return Colors.yellow;
      case DownloadTaskStatus.running:
        return Colors.deepPurple;
      case DownloadTaskStatus.complete:
        return Colors.green;
      case DownloadTaskStatus.failed:
        return Colors.red;
      case DownloadTaskStatus.canceled:
        return Colors.redAccent;
      case DownloadTaskStatus.paused:
        return Colors.black;
    }
  }

  bool get isRunning => this == DownloadTaskStatus.running;
  bool get isCompleted => this == DownloadTaskStatus.complete;
  bool get isFailed => this == DownloadTaskStatus.failed;
  bool get isCancelled => this == DownloadTaskStatus.canceled;
  bool get isEnqueued => this == DownloadTaskStatus.enqueued;
  bool get isUndefined => this == DownloadTaskStatus.undefined;
  bool get isPaused => this == DownloadTaskStatus.paused;
}

/// An assert statement that will never throw error.
///
/// Use this when we need implement code that should only run in debug mode.
///
void proxyAssert(VoidCallback callback) {
  assert(() {
    try {
      callback();
    } catch (e) {} // ignore: empty_catches

    return true;
  }());
}

typedef TestPredicate<T> = bool Function(T);
