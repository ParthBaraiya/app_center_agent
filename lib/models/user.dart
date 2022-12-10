import 'package:app_center_agent/utils/enums.dart';
import 'package:app_center_agent/utils/shared_preferences_util.dart';
import 'package:flutter/foundation.dart';

@immutable

/// Stores the data for a user.
class User {
  final String id;
  final String? avatar;
  final bool canChangePassword;
  final String displayName;
  final String email;
  final String name;
  final List<UserPermission> permissions;
  final CreationOrigin origin;
  final String authToken;

  const User({
    required this.id,
    required this.avatar,
    required this.canChangePassword,
    required this.displayName,
    required this.email,
    required this.name,
    required this.origin,
    required this.permissions,
    this.authToken = '',
  });

  String get initials {
    return (displayName.isEmpty ? email[0] : displayName[0]).toUpperCase();
  }

  factory User.fromJson(Map<String, dynamic> json, {String token = ''}) => User(
        id: json['id'] as String,
        avatar: json['avatar_url'] as String?,
        name: json['name'] as String,
        email: json['email'] as String,
        canChangePassword: json['can_change_password'] as bool? ?? false,
        displayName: json['display_name'] as String,
        origin: (json['origin'] as String).toCreationOrigin,
        permissions: (json['permissions'] as List?)
                ?.map((e) => (e as String).toUserPermission)
                .where((element) => element != null)
                .cast<UserPermission>()
                .toList() ??
            [],
        authToken: json['token'] ?? token,
      );

  User updateToken(String token) => User(
      id: id,
      avatar: avatar,
      canChangePassword: canChangePassword,
      displayName: displayName,
      email: email,
      name: name,
      origin: origin,
      permissions: permissions,
      authToken: token);

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar_url': avatar,
        'name': name,
        'email': email,
        'can_change_password': canChangePassword,
        'display_name': displayName,
        'origin': origin.mappingString,
        'permissions': permissions.map((e) => e.mappingString).toList(),
        'token': authToken,
      };

  Future<void> saveToPreferences() =>
      SharedPreferencesUtility.saveUser(user: this);

  @override
  bool operator ==(covariant User other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}
