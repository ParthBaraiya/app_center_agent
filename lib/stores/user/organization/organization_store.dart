import 'package:app_center_agent/apiservice/repository.dart';
import 'package:app_center_agent/models/appcenter_application.dart';
import 'package:app_center_agent/models/organization.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user/organization/app/app_center_application_list_store.dart';
import 'package:app_center_agent/stores/user/user_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:mobx/mobx.dart';

part 'organization_store.g.dart';

class OrganizationStore extends _OrganizationStore with _$OrganizationStore {
  OrganizationStore({
    required super.name,
    required super.displayName,
    required super.origin,
    required super.user,
  });

  OrganizationStore.fromOrganizationAndUserAndApps({
    required Organization organization,
    required super.user,
    required List<AppCenterApplication> apps,
  }) : super(
          displayName: organization.displayName,
          name: organization.name,
          origin: organization.origin,
        ) {
    this.apps = AppCenterApplicationListStore(
      organization: this,
      apps: apps,
    );
  }

  late final AppCenterApplicationListStore apps;
}

abstract class _OrganizationStore extends NetworkStore with Store {
  _OrganizationStore({
    required String name,
    required String displayName,
    required CreationOrigin origin,
    required this.user,
  })  : _name = name,
        _displayName = displayName,
        _origin = origin {
    loadOrganization();
  }

  late final String _name;
  late final String _displayName;
  late final CreationOrigin _origin;
  late final UserStore user;

  @observable
  OrganizationDetails? organization;

  @computed
  CreationOrigin get origin => organization?.origin ?? _origin;

  @computed
  String get name => organization?.name ?? _name;

  @computed
  String get displayName => organization?.displayName ?? _displayName;

  Future<void> loadOrganization({bool force = false}) async {
    if (_name.isEmpty) return;

    await networkCall(() async {
      if (organization != null && !force) return;
      organization = await ApiRepository.instance
          .getOrganization(name: name, token: user.token);
    });
  }
}
