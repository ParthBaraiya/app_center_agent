import 'package:app_center_agent/stores/user/organization/organization_store.dart';
import 'package:app_center_agent/stores/user/user_store.dart';
import 'package:flutter/foundation.dart';

import '../utils/enums.dart';

class Organization {
  final String name;
  final String displayName;
  final CreationOrigin origin;

  const Organization({
    required this.name,
    required this.displayName,
    required this.origin,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      origin:
          (json['origin'] as String?)?.toCreationOrigin ?? CreationOrigin.none,
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

@immutable
class OrganizationDetails {
  final String displayName;
  final String name;
  final CreationOrigin origin;
  final String id;
  final String? avatar;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  const OrganizationDetails({
    required this.displayName,
    required this.name,
    required this.origin,
    required this.avatar,
    required this.id,
    required this.createdDate,
    required this.updatedDate,
  });

  String get initials => displayName.isEmpty ? 'O' : displayName[0];

  factory OrganizationDetails.fromJson(Map<String, dynamic> json) =>
      OrganizationDetails(
        displayName: json['display_name'] as String,
        name: json['name'] as String,
        origin: (json['origin'] as String).toCreationOrigin,
        createdDate: DateTime.tryParse(json['created_at'] as String? ?? ''),
        updatedDate: DateTime.tryParse(json['updated_at'] as String? ?? ''),
        avatar: json['avatar_url'] as String?,
        id: json['id'],
      );

  @override
  // ignore: hash_and_equals
  bool operator ==(covariant OrganizationDetails other) => id == other.id;
}
