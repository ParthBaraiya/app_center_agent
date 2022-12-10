import 'dart:collection';

import 'package:app_center_agent/apiservice/repository.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user/organization/app/groups/app_center_app_group_store.dart';
import 'package:app_center_agent/stores/user/organization/app/release/app_center_release_store.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:mobx/mobx.dart';

part 'app_center_release_list_store.g.dart';

class AppCenterReleaseListStore = _AppCenterReleaseListStore
    with _$AppCenterReleaseListStore;

abstract class _AppCenterReleaseListStore extends NetworkStore with Store {
  final AppCenterAppGroupStore group;

  _AppCenterReleaseListStore({
    required this.group,
  });

  @observable
  List<AppCenterReleaseStore> _releases = [];

  @computed
  UnmodifiableListView<AppCenterReleaseStore> get releases =>
      UnmodifiableListView(_releases);

  AppCenterReleaseStore? getReleaseById(int id) {
    return _releases.firstWhereOrNull((e) => e.model.id == id);
  }

  Future<void> fetchAllReleases({bool force = false}) async {
    return networkCall(() async {
      final owner = group.app.app.owner?.name;
      final app = group.app.app.name;
      final groupName = group.group.name;

      if ((_releases.isNotEmpty && !force) ||
          owner == null ||
          owner.isEmpty ||
          app == null ||
          app.isEmpty ||
          groupName == null ||
          groupName.isEmpty) return;

      _releases = (await ApiRepository.instance.getAppRelease(
        owner: owner,
        app: app,
        group: groupName,
      ))
          .map((e) => AppCenterReleaseStore(model: e, group: group))
          .toList();
    });
  }
}
