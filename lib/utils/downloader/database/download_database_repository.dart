import 'package:app_center_agent/utils/downloader/database/schema/app_download_schema.dart';
import 'package:app_center_agent/utils/factories/database_factory/isar_database_factory.dart';
import 'package:app_center_agent/utils/repositories/isar_database_repository.dart';
import 'package:isar/isar.dart';

class DownloadDatabaseRepository extends IsarDatabaseRepository {
  // static DownloadDatabaseRepository? _instance;
  // static DownloadDatabaseRepository get instance => _instance!;

  // static Future<DownloadDatabaseRepository> init() async {
  //   _instance = DownloadDatabaseRepository(
  //     factory: await IsarDatabaseFactory.init(),
  //   );
  //
  //   return _instance!;
  // }

  DownloadDatabaseRepository({required super.factory});

  @override
  IsarDatabaseConfigs get configs => const IsarDatabaseConfigs(
        name: 'app_downloads',
        schemas: {AppDownloadDataSchema},
      );

  Future<void> saveDownload(AppDownloadData data) {
    return withIsar((database) async {
      final collection = database.appDownloadDatas;

      final result = await database
          .txn(collection.filter().taskIdEqualTo(data.taskId).findFirst);

      if (result != null) {
        return;
      }

      await database.writeTxn(() => collection.put(data));
    });
  }

  Future<List<AppDownloadData>> getDownloadList() async {
    return (await withIsar((database) async {
          final collection = database.appDownloadDatas;

          final result = await database
              .txn(collection.where(sort: Sort.desc).sortByTaskId().findAll);

          return result;
        })) ??
        [];
  }

  Future<void> deleteDownload(AppDownloadData data) {
    return withIsar((database) async {
      final collection = database.appDownloadDatas;

      await database.writeTxn(() => collection.delete(data.id));
    });
  }

  Future<AppDownloadData?> getDownloadForRelease({
    required String organization,
    required String app,
    required int release,
  }) {
    return withIsar((database) async {
      final collection = database.appDownloadDatas;

      return database.txn(collection
          .filter()
          .organizationEqualTo(organization)
          .appNameEqualTo(app)
          .releaseIdEqualTo(release)
          .findFirst);
    });
  }

  Future<Stream> listen() async {
    return (await withIsar((database) {
      return Future.value(database.appDownloadDatas.watchLazy());
    }))!;
  }

  ///
  Future<String?> taskIdForDownload(AppDownloadData data) {
    return withIsar((database) async {
      final collection = database.appDownloadDatas;

      final result = await database.txn(() => collection
          .filter()
          .appNameEqualTo(data.appName)
          .releaseIdEqualTo(data.releaseId)
          .organizationEqualTo(data.organization)
          .findFirst());

      return result?.taskId;
    });
  }
}
