import 'dart:convert';

import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/organization_list_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:app_center_agent/utils/shared_preferences_util.dart';
import 'package:app_center_agent/values/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../apiservice/repository.dart';

part 'user_store.g.dart';

class UserStore extends _UserStore with _$UserStore {
  UserStore({required super.token});

  UserStore.fromUser({required User user, bool update = true})
      : super.fromUser(user: user) {
    if (update) {
      loadUserData();
    }
  }

  UserStore.fromJson({required Map<String, dynamic> json, bool update = true})
      : super.fromJson(json: json) {
    if (update) {
      loadUserData();
    }
  }

  UserStore.fromJsonString({required String json, bool update = true})
      : super.fromJsonString(json: json) {
    if (update) {
      loadUserData();
    }
  }

  late final organizations = OrganizationListStore(user: this);

  Future<void> loadUserData({bool force = false}) async {
    if ((token.isEmpty || user != null) && !force) return;

    await networkCall(() async {
      user = (await ApiRepository.instance.getUser(token: token));
      user!.saveToPreferences();
    });
  }
}

abstract class _UserStore extends NetworkStore with Store {
  _UserStore({required this.token});

  // ignore: prefer_initializing_formals
  _UserStore.fromUser({required User user}) : user = user {
    if (user.authToken.isEmpty) {
      throw AppStrings.invalidAuthToken;
    }
    token = user.authToken;
  }

  _UserStore.fromJson({required Map<String, dynamic> json}) {
    final user = User.fromJson(json);

    if (user.authToken.isEmpty) {
      throw AppStrings.invalidAuthToken;
    }
    this.user = user;
    token = user.authToken;
  }

  _UserStore.fromJsonString({required String json, bool update = true}) {
    final user = User.fromJson(jsonDecode(json));

    if (user.authToken.isEmpty) {
      throw AppStrings.invalidAuthToken;
    }
    this.user = user;
    token = user.authToken;
  }

  late final String token;

  @observable
  User? user;
}

// TODO: move this data to store. and rename store with User.
@immutable
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
  // ignore: hash_and_equals
  bool operator ==(covariant User other) => other.id == id;
}
