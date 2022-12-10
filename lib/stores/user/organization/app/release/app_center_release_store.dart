import 'package:app_center_agent/apiservice/repository.dart';
import 'package:app_center_agent/models/app_center_release.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user/organization/app/groups/app_center_app_group_store.dart';
import 'package:mobx/mobx.dart';

part 'app_center_release_store.g.dart';

class AppCenterReleaseStore = _AppCenterReleaseStore
    with _$AppCenterReleaseStore;

abstract class _AppCenterReleaseStore extends NetworkStore with Store {
  final AppCenterRelease model;
  final AppCenterAppGroupStore group;

  _AppCenterReleaseStore({
    required this.model,
    required this.group,
  });

  @observable
  AppCenterReleaseDetails? _details;

  @computed
  AppCenterReleaseDetails? get details => _details;

  Future<void> getReleaseDetails({bool force = true}) async {
    return networkCall(() async {
      if ((_details != null && !force) ||
          group.app.app.owner?.name == null ||
          group.app.app.name == null ||
          group.group.name == null ||
          model.id == null) return;

      _details = await ApiRepository.instance.getAppReleaseDetails(
        owner: group.app.app.owner!.name!,
        app: group.app.app.name!,
        group: group.group.name!,
        releaseId: model.id!,
      );
    });
  }
}
