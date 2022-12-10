import 'package:app_center_agent/app_configs.dart';
import 'package:app_center_agent/modules/download_list_screen/download_task/download_task_store.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user/organization/app/release/app_center_release_store.dart';
import 'package:app_center_agent/utils/downloader/database/schema/app_download_schema.dart';
import 'package:mobx/mobx.dart';

part 'app_release_details_download_store.g.dart';

class AppReleaseDetailsDownloadStore = _AppReleaseDetailsDownloadStore
    with _$AppReleaseDetailsDownloadStore;

abstract class _AppReleaseDetailsDownloadStore extends NetworkStore with Store {
  final AppCenterReleaseStore? store;

  _AppReleaseDetailsDownloadStore({
    required this.store,
  });

  @observable
  DownloadTaskStore? downloadTask;

  Future<void> startDownload() async {
    if (store == null) return;

    final url = store!.details!.installUrl!;

    await AppConfigs.downloader.startAppDownload(
      force: true,
      downloadConfigs: AppDownloadData.create(
        appName: store!.group.app.app.name!,
        releaseId: store!.details!.id!,
        organization: store!.group.app.organization.name,
        downloadUrl: url,
      ),
    );

    await getDownloadStatus();
  }

  Future<void> getDownloadStatus() {
    return networkCall(() async {
      if (store?.group.app.organization.name == null ||
          store!.group.app.app.name == null ||
          store!.model.id == null) return;

      final download =
          await AppConfigs.databaseRepository.getDownloadForRelease(
        organization: store!.group.app.organization.name,
        app: store!.group.app.app.name!,
        release: store!.model.id!,
      );

      if (download != null) {
        downloadTask = DownloadTaskStore(task: download);
      }
    });
  }
}
