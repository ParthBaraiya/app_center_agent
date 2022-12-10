import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';

@immutable
abstract class DatabaseConfig<Schema> {
  final String name;
  final Set<Schema> schemas;

  const DatabaseConfig({
    required this.name,
    required this.schemas,
  });

  bool hasSameSchemaSet(Set<Schema> newSchemas);

  @override
  bool operator ==(covariant DatabaseConfig other) => other.name == name;

  @override
  int get hashCode => name.hashCode;
}

abstract class DataBaseFactory<Schema, T extends DatabaseConfig<Schema>,
    Database> {
  DataBaseFactory({
    required this.saveDir,
  });

  final String saveDir;

  UnmodifiableSetView<Schema> getSchemaSetForDatabase(String name) =>
      UnmodifiableSetView({});

  Future<Database?> getDatabase({
    required T configs,
  });

  Future<void> closeDatabase(String name);

  /// Returns true if all the instances were closed.
  /// Returns false if one or more instances failed to close.
  Future<bool> dispose();
}
