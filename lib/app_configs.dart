import 'package:app_center_agent/stores/user/user_account_list_store.dart';
import 'package:app_center_agent/utils/downloader/database/download_database_repository.dart';
import 'package:app_center_agent/utils/downloader/file_downloader_utility.dart';
import 'package:app_center_agent/utils/factories/database_factory/isar_database_factory.dart';

class AppConfigs {
  late final DownloadDatabaseRepository _databaseRepository;
  late final UsersListStore _users;
  late final FileDownloaderUtility _downloader;

  AppConfigs._({
    required DownloadDatabaseRepository databaseRepository,
    required UsersListStore users,
    required FileDownloaderUtility downloader,
  })  : _databaseRepository = databaseRepository,
        _users = users,
        _downloader = downloader;

  Future<void> dispose() async {
    await _downloader.dispose();
    await _databaseRepository.dispose();
  }

  //#region Static Methods and Fields
  static Future<void> init() async {
    if (_instance == null) {
      // TODO: add exception handling...
      final users = UsersListStore();
      await users.loadDataFromSharedPreferences();

      final repository = DownloadDatabaseRepository(
        factory: await IsarDatabaseFactory.init(),
      );

      final downloader = FileDownloaderUtility(
        repository: repository,
      );

      await downloader.init();

      _instance ??= AppConfigs._(
        databaseRepository: repository,
        users: users,
        downloader: downloader,
      );
    }

    return;
  }

  static AppConfigs? _instance;

  static AppConfigs? get instance => _instance;
  static DownloadDatabaseRepository get databaseRepository =>
      _instance!._databaseRepository;
  static UsersListStore get users => _instance!._users;
  static FileDownloaderUtility get downloader => _instance!._downloader;
  //#endregion
}
