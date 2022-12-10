import 'dart:async';

import 'package:app_center_agent/utils/factories/database_factory/isar_database_factory.dart';
import 'package:app_center_agent/utils/repositories/database_repository.dart';
import 'package:isar/isar.dart';

typedef IsarDatabaseProvider<T> = Future<T?> Function(Isar database);

abstract class IsarDatabaseRepository extends DatabaseRepository {
  IsarDatabaseRepository({required super.factory});

  IsarDatabaseConfigs get configs;

  Isar? _isar;

  Completer<bool>? _completer;

  Future<bool> get initialized async {
    if (_completer == null) {
      open();
    }

    return (await _completer!.future) && _isar != null;
  }

  Future<void> open() async {
    if (_completer?.isCompleted ?? false) {
      return;
    }
    _completer = Completer<bool>();
    _isar = await factory.getDatabase(configs: configs);
    if (!(_completer?.isCompleted ?? true)) {
      _completer!.complete(true);
    }
  }

  Future<T?> withIsar<T>(IsarDatabaseProvider<T> callback) async {
    if (await initialized) {
      return await callback(_isar!);
    }

    return Future.value();
  }

  Future<void> dispose() => factory.closeDatabase(configs.name);
}
