import 'package:app_center_agent/models/appcenter_application.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user/organization/app/groups/app_center_app_groups_list_store.dart';
import 'package:app_center_agent/stores/user/organization/organization_store.dart';
import 'package:mobx/mobx.dart';

part 'app_center_application_store.g.dart';

class AppCenterApplicationStore extends _AppCenterApplicationStore
    with _$AppCenterApplicationStore {
  AppCenterApplicationStore({
    required super.app,
    required super.organization,
  });

  late final groups = AppCenterAppGroupsListStore(app: this);
}

abstract class _AppCenterApplicationStore extends NetworkStore with Store {
  final AppCenterApplication app;
  final OrganizationStore organization;

  _AppCenterApplicationStore({
    required this.app,
    required this.organization,
  });
}
