import 'dart:collection';

import 'package:app_center_agent/models/appcenter_application.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user/organization/app/app_center_application_store.dart';
import 'package:app_center_agent/stores/user/organization/organization_store.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:mobx/mobx.dart';

part 'app_center_application_list_store.g.dart';

class AppCenterApplicationListStore = _AppCenterApplicationListStore
    with _$AppCenterApplicationListStore;

abstract class _AppCenterApplicationListStore extends NetworkStore with Store {
  final OrganizationStore organization;

  _AppCenterApplicationListStore({
    required this.organization,
    List<AppCenterApplication> apps = const [],
  }) {
    _apps.addAll(apps.map((e) => AppCenterApplicationStore(
          app: e,
          organization: organization,
        )));
  }

  @observable
  List<AppCenterApplicationStore> _apps = [];

  @computed
  UnmodifiableListView<AppCenterApplicationStore> get apps =>
      UnmodifiableListView(_apps);

  AppCenterApplicationStore? getAppByName(String name) {
    return _apps.firstWhereOrNull((element) => element.app.name == name);
  }

  // Future<void> fetchAppList({bool force = false}) async {
  //   return networkCall(() async {
  //     if (_apps.isNotEmpty && !force) return;
  //
  //     final appStores =
  //         (await ApiRepository.instance.getAppsListForOrganization(
  //       name: organization.name,
  //       token: organization.user.token,
  //     ))
  //             .map((e) => AppCenterApplicationStore(app: e))
  //             .toList();
  //
  //     _apps = appStores;
  //   });
  // }
}
