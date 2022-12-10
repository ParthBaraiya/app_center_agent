import 'package:app_center_agent/models/organization.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:flutter/cupertino.dart';

class AppCenterApplication {
  final String? id;
  final String? description;
  final String? displayName;
  final String? releaseType;
  final String? iconUrl;
  final String? iconSource;
  final String? name;
  final String? os;
  final AppOwner? owner;
  final String? appSecret;
  final AppAzureSubscription? azureSubscription;
  final String? platform;
  final CreationOrigin? origin;
  final String? createdAt;
  final String? updatedAt;
  final List<String>? memberPermissions;

  AppCenterApplication({
    this.id,
    this.description,
    this.displayName,
    this.releaseType,
    this.iconUrl,
    this.iconSource,
    this.name,
    this.os,
    this.owner,
    this.appSecret,
    this.azureSubscription,
    this.platform,
    this.origin,
    this.createdAt,
    this.updatedAt,
    this.memberPermissions,
  });

  factory AppCenterApplication.fromJson(Map<String, dynamic> json) =>
      AppCenterApplication(
        id: json['id'],
        description: json['description'],
        displayName: json['display_name'],
        releaseType: json['release_type'],
        iconUrl: json['icon_url'],
        iconSource: json['icon_source'],
        name: json['name'],
        os: json['os'],
        owner: json['owner'] == null ? null : AppOwner.fromJson(json['owner']),
        appSecret: json['app_secret'],
        azureSubscription: json['azure_subscription'] == null
            ? null
            : AppAzureSubscription.fromJson(json['azure_subscription']),
        platform: json['platform'],
        origin: (json['origin'] as String?)?.toCreationOrigin,
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        memberPermissions: json['member_permissions'] == null
            ? []
            : List<String>.from(json['member_permissions']!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'display_name': displayName,
        'release_type': releaseType,
        'icon_url': iconUrl,
        'icon_source': iconSource,
        'name': name,
        'os': os,
        'owner': owner?.toJson(),
        'app_secret': appSecret,
        'azure_subscription': azureSubscription?.toJson(),
        'platform': platform,
        'origin': origin,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'member_permissions': memberPermissions == null
            ? []
            : List<dynamic>.from(memberPermissions!.map((x) => x)),
      };
}

class AppAzureSubscription {
  final String? subscriptionId;
  final String? tenantId;
  final String? subscriptionName;
  final bool? isBilling;
  final bool? isBillable;
  final bool? isMicrosoftInternal;

  AppAzureSubscription({
    this.subscriptionId,
    this.tenantId,
    this.subscriptionName,
    this.isBilling,
    this.isBillable,
    this.isMicrosoftInternal,
  });

  factory AppAzureSubscription.fromJson(Map<String, dynamic> json) =>
      AppAzureSubscription(
        subscriptionId: json['subscription_id'],
        tenantId: json['tenant_id'],
        subscriptionName: json['subscription_name'],
        isBilling: json['is_billing'],
        isBillable: json['is_billable'],
        isMicrosoftInternal: json['is_microsoft_internal'],
      );

  Map<String, dynamic> toJson() => {
        'subscription_id': subscriptionId,
        'tenant_id': tenantId,
        'subscription_name': subscriptionName,
        'is_billing': isBilling,
        'is_billable': isBillable,
        'is_microsoft_internal': isMicrosoftInternal,
      };
}

@immutable
class AppOwner {
  final String? id;
  final String? avatarUrl;
  final String? displayName;
  final String? email;
  final String? name;
  final String? type;

  const AppOwner({
    this.id,
    this.avatarUrl,
    this.displayName,
    this.email,
    this.name,
    this.type,
  });

  factory AppOwner.fromJson(Map<String, dynamic> json) => AppOwner(
        id: json['id'],
        avatarUrl: json['avatar_url'],
        displayName: json['display_name'],
        email: json['email'],
        name: json['name'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar_url': avatarUrl,
        'display_name': displayName,
        'email': email,
        'name': name,
        'type': type,
      };

  Organization organization(CreationOrigin origin) => Organization(
        name: name ?? 'N/A',
        displayName: displayName ?? 'N/A',
        origin: origin,
      );

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(covariant AppOwner other) => other.id == id;
}
