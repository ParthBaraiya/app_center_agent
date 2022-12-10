import 'package:app_center_agent/utils/factories/database_factory/database_factory.dart';

class DatabaseRepository<Schema, T extends DatabaseConfig<Schema>, Database,
    S extends DataBaseFactory<Schema, T, Database>> {
  final S factory;

  DatabaseRepository({
    required this.factory,
  });
}
