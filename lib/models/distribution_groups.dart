import 'package:app_center_agent/utils/enums.dart';

class AppCenterGroup {
  final String? id;
  final String? name;
  final String? displayName;
  final CreationOrigin origin;
  final bool? isPublic;

  AppCenterGroup({
    required this.id,
    required this.name,
    required this.displayName,
    required this.origin,
    required this.isPublic,
  });

  factory AppCenterGroup.fromJson(Map<String, dynamic> json) => AppCenterGroup(
        id: json['id'],
        name: json['name'],
        displayName: json['display_name'],
        origin: (json['origin'] as String?)?.toCreationOrigin ??
            CreationOrigin.none,
        isPublic: json['is_public'],
      );

  String get privacyDisplay => isPublic == null
      ? 'N/A'
      : isPublic!
          ? 'Public'
          : 'Private';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'display_name': displayName,
        'origin': origin,
        'is_public': isPublic,
      };
}

class AppCenterGroupDetails {
  final String? id;
  final String? name;
  final String? displayName;
  final String? origin;
  final bool? isPublic;
  final int? totalAppsCount;
  final int? totalUsersCount;
  // final List<App>? apps;

  AppCenterGroupDetails({
    this.id,
    this.name,
    this.displayName,
    this.origin,
    this.isPublic,
    this.totalAppsCount,
    this.totalUsersCount,
    // this.apps,
  });

  factory AppCenterGroupDetails.fromJson(Map<String, dynamic> json) =>
      AppCenterGroupDetails(
        id: json['id'],
        name: json['name'],
        displayName: json['display_name'],
        origin: json['origin'],
        isPublic: json['is_public'],
        totalAppsCount: json['total_apps_count'],
        totalUsersCount: json['total_users_count'],
        // apps: json["apps"] == null ? [] : List<App>.from(json["apps"]!.map((x) => App.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'display_name': displayName,
        'origin': origin,
        'is_public': isPublic,
        'total_apps_count': totalAppsCount,
        'total_users_count': totalUsersCount,
        // "apps": apps == null ? [] : List<dynamic>.from(apps!.map((x) => x.toJson())),
      };
}
