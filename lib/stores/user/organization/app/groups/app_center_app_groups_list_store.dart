import 'dart:collection';

import 'package:app_center_agent/apiservice/repository.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user/organization/app/app_center_application_store.dart';
import 'package:app_center_agent/stores/user/organization/app/groups/app_center_app_group_store.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:mobx/mobx.dart';

part 'app_center_app_groups_list_store.g.dart';

class AppCenterAppGroupsListStore = _AppCenterAppGroupsListStore
    with _$AppCenterAppGroupsListStore;

abstract class _AppCenterAppGroupsListStore extends NetworkStore with Store {
  final AppCenterApplicationStore app;

  _AppCenterAppGroupsListStore({
    required this.app,
  });

  @observable
  List<AppCenterAppGroupStore> _groups = [];

  @computed
  UnmodifiableListView<AppCenterAppGroupStore> get groups =>
      UnmodifiableListView(_groups);

  Future<void> listDistributionGroups({bool force = false}) {
    return networkCall(() async {
      if ((app.app.name == null || app.app.owner?.name == null) && !force) {
        return;
      }

      _groups = (await ApiRepository.instance.getDistributionGroupsForApp(
        appOwnerName: app.app.owner!.name!,
        appName: app.app.name!,
      ))
          .map((e) => AppCenterAppGroupStore(group: e, app: app))
          .toList();
    });
  }

  AppCenterAppGroupStore? getGroupByName(String name) {
    return _groups.firstWhereOrNull((e) => e.group.name == name);
  }
}
