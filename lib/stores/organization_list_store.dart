import 'package:app_center_agent/apiservice/repository.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/organization_store.dart';
import 'package:app_center_agent/stores/user_store.dart';
import 'package:mobx/mobx.dart';

part 'organization_list_store.g.dart';

class OrganizationListStore = _OrganizationListStore
    with _$OrganizationListStore;

abstract class _OrganizationListStore extends NetworkStore with Store {
  _OrganizationListStore({required this.user}) {
    loadOrganizations();
  }

  final UserStore user;
  final organizations = ObservableMap<String, OrganizationStore>.of({});

  void loadOrganizations({bool force = false}) async {
    if (organizations.isNotEmpty && !force) return;

    await networkCall(() async {
      final orgs =
          await ApiRepository.instance.getOrganizationList(token: user.token);

      for (final organization in orgs) {
        organizations.addAll({
          organization.name: organization.getStore(parent: user),
        });
      }
    });
  }
}
