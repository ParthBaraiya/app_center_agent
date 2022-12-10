import 'package:app_center_agent/models/distribution_groups.dart';
import 'package:app_center_agent/stores/user/organization/app/app_center_application_store.dart';
import 'package:app_center_agent/stores/user/organization/app/release/app_center_release_list_store.dart';
import 'package:mobx/mobx.dart';

part 'app_center_app_group_store.g.dart';

class AppCenterAppGroupStore extends _AppCenterAppGroupStore
    with _$AppCenterAppGroupStore {
  AppCenterAppGroupStore({
    required super.group,
    required super.app,
  });

  late final release = AppCenterReleaseListStore(group: this);
}

abstract class _AppCenterAppGroupStore with Store {
  final AppCenterGroup group;
  final AppCenterApplicationStore app;

  _AppCenterAppGroupStore({
    required this.group,
    required this.app,
  });
}
