import 'package:app_center_agent/stores/organization_store.dart';
import 'package:app_center_agent/stores/user_store.dart';

import '../utils/enums.dart';

class OrganizationListResponse {
  List<OrganizationResponse> organizations;

  OrganizationListResponse({
    required this.organizations,
  });

  factory OrganizationListResponse.fromJson(List<Map<String, dynamic>> list) {
    final orgs = <OrganizationResponse>[];
    for (final organization in list) {
      orgs.add(OrganizationResponse.fromJson(organization));
    }

    return OrganizationListResponse(organizations: orgs);
  }
}

class OrganizationResponse {
  final String name;
  final String displayName;
  final CreationOrigin origin;

  const OrganizationResponse({
    required this.name,
    required this.displayName,
    required this.origin,
  });

  factory OrganizationResponse.fromJson(Map<String, dynamic> json) {
    return OrganizationResponse(
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      origin: (json['origin'] as String).toCreationOrigin,
    );
  }

  OrganizationStore getStore({required UserStore parent}) {
    return OrganizationStore(
      displayName: displayName,
      name: name,
      origin: origin,
      user: parent,
    );
  }
}
