import 'package:app_center_agent/apiservice/repository.dart';
import 'package:app_center_agent/models/appcenter_application.dart';
import 'package:app_center_agent/models/organization.dart';
import 'package:app_center_agent/models/search_models/search_application_data.dart';
import 'package:app_center_agent/models/search_models/search_distribution_group_data.dart';
import 'package:app_center_agent/models/search_models/search_organization_data.dart';
import 'package:app_center_agent/models/search_models/search_release_data.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user/organization/app/app_center_application_store.dart';
import 'package:app_center_agent/stores/user/organization/app/groups/app_center_app_group_store.dart';
import 'package:app_center_agent/stores/user/organization/app/release/app_center_release_store.dart';
import 'package:app_center_agent/stores/user/organization/organization_store.dart';
import 'package:app_center_agent/stores/user/user_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'organization_list_store.g.dart';

/// Stores the list of all the organizations of the list.
///
class OrganizationListStore = _OrganizationListStore
    with _$OrganizationListStore;

abstract class _OrganizationListStore extends NetworkStore with Store {
  _OrganizationListStore({required this.user}) {
    loadOrganizations();
  }

  /// Loads current user.
  final UserStore user;

  /// Loads all the organizations for current user.
  final organizations = ObservableMap<String, OrganizationStore>.of({});

  /// Loads all the organizations from API.
  Future<void> loadOrganizations({bool force = false}) async {
    await networkCall(() async {
      if (organizations.isNotEmpty && !force) return;

      final apps = await ApiRepository.instance.getAllAppsForUser(
        token: user.token,
      );

      final organizationAppMap = <String, List<AppCenterApplication>>{};
      final organizationMap = <String, Organization>{};

      for (final app in apps.where((app) {
        if (app.owner?.type != 'org') {
          debugPrint('${app.owner?.type}');
        }
        return app.owner?.name != null && app.owner?.type == 'org';
      })) {
        final orgName = app.owner!.name!;

        if (organizationMap[orgName] == null) {
          final org =
              app.owner!.organization(app.origin ?? CreationOrigin.none);
          organizationMap[orgName] = org;
        }

        organizationAppMap.update(
          orgName,
          (value) => value..add(app),
          ifAbsent: () => [app],
        );
      }

      organizations.addAll(organizationMap.map((key, value) {
        return MapEntry(
          key,
          OrganizationStore.fromOrganizationAndUserAndApps(
            organization: value,
            apps: organizationAppMap[key] ?? [],
            user: user,
          ),
        );
      }));
    });
  }

  /// Search the organization from the list fetched from API.
  OrganizationStore? getOrganizationByName(
      {required SearchOrganizationData request}) {
    // TODO: check for the list of organizations.
    // And call the API if organization is not found.
    return organizations[request.organization];
  }

  /// Search the application from the stored data.
  AppCenterApplicationStore? getApplicationByName({
    required SearchApplicationData request,
  }) {
    final org = getOrganizationByName(request: request);
    if (org == null) return null;

    return org.apps.getAppByName(request.app);
  }

  /// Search the distribution group from the stored data.
  AppCenterAppGroupStore? getDistributionGroup({
    required SearchDistributionGroupData request,
  }) {
    final application = getApplicationByName(request: request);

    if (application == null) return null;

    return application.groups.getGroupByName(request.group);
  }

  /// Search the release from the stored data.
  AppCenterReleaseStore? getReleaseById({
    required SearchReleaseData request,
  }) {
    final distributionGroup = getDistributionGroup(request: request);

    if (distributionGroup == null) return null;

    return distributionGroup.release.getReleaseById(request.releaseId);
  }
}
