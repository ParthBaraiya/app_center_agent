import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:app_center_agent/utils/factories/database_factory/database_factory.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class IsarDatabaseConfigs extends DatabaseConfig<CollectionSchema> {
  const IsarDatabaseConfigs({required super.name, required super.schemas});

  @override
  bool hasSameSchemaSet(Set<CollectionSchema> newSchemas) {
    return schemas.containsAll(newSchemas) && newSchemas.containsAll(schemas);
  }
}

class IsarDatabaseFactory
    extends DataBaseFactory<CollectionSchema, IsarDatabaseConfigs, Isar> {
  static Future<IsarDatabaseFactory> init() async {
    final dir = Directory(
        path.join((await getApplicationSupportDirectory()).path, 'database'));

    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    return IsarDatabaseFactory(saveDir: dir.path);
  }

  IsarDatabaseFactory({
    required super.saveDir,
  });

  final _databases = <String, Completer<Isar?>>{};
  final _schemaSet = <String, Set<CollectionSchema>>{};

  @override
  UnmodifiableSetView<CollectionSchema> getSchemaSetForDatabase(String name) {
    return UnmodifiableSetView(_schemaSet[name] ?? {});
  }

  @override
  Future<Isar?> getDatabase({
    required IsarDatabaseConfigs configs,
  }) {
    var completer = _databases[configs.name];

    if (completer != null) {
      if (configs.hasSameSchemaSet(_schemaSet[configs.name] ?? {})) {
        return completer.future;
      } else {
        throw 'There is already a database registered with the same name '
            'but different schema set.';
      }
    }

    var isar = Isar.getInstance(configs.name);

    if (isar == null) {
      completer = Completer<Isar?>();

      _databases[configs.name] = completer;
      _schemaSet[configs.name] = configs.schemas;

      Isar.open(configs.schemas.toList(), directory: saveDir).then((value) {
        if (!completer!.isCompleted) {
          completer.complete(value);
        }
      }).catchError((e, stack) {
        if (!completer!.isCompleted) {
          completer.completeError(e, stack);
        }
      });
    } else {
      throw 'Database is already registered but it\'s not recorded.';
    }

    return completer.future;
  }

  @override
  Future<void> closeDatabase(String name) async {
    final isar = Isar.getInstance(name);

    if (isar != null) {
      if (await isar.close()) {
        _schemaSet.remove(name);
        _databases.remove(name);
      } else {
        throw 'Failed to close the database';
      }
    } else if (_databases[name] != null) {
      final isar = await _databases[name]?.future;

      if ((await isar?.close()) ?? true) {
        _databases.remove(name);
        _schemaSet.remove(name);
      }
    }
  }

  /// Returns true if all the instances were closed.
  /// Returns false if one or more instances failed to close.
  @override
  Future<bool> dispose() async {
    final closed = (await Future.wait<bool>(Isar.instanceNames
            .map((e) => Isar.getInstance(e))
            .where((element) => element != null)
            .cast<Isar>()
            .map((e) => e.close())))
        .fold<bool>(true, (previousValue, element) => previousValue && element);

    _databases.removeWhere((key, value) => !Isar.instanceNames.contains(key));
    _schemaSet.removeWhere((key, value) => !Isar.instanceNames.contains(key));

    return closed;
  }
}
