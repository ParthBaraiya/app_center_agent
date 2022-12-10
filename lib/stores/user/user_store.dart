import 'dart:convert';

import 'package:app_center_agent/models/user.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user/organization/organization_list_store.dart';
import 'package:app_center_agent/values/app_strings.dart';
import 'package:mobx/mobx.dart';

import '../../apiservice/repository.dart';

part 'user_store.g.dart';

/// Stores the details of a single user.
///
class UserStore extends _UserStore with _$UserStore {
  UserStore({required super.token});

  /// Initializes the [UserStore] instance from the instance of the [User] class.
  ///
  /// [update] field defines whether we should call API to update the user data
  /// or not.
  factory UserStore.fromUser({
    required User user,
    bool update = true,
  }) {
    if (user.authToken.isEmpty) {
      throw AppStrings.invalidAuthToken;
    }

    final store = UserStore(token: user.authToken)..user = user;

    if (update) {
      store.loadUserData();
    }

    return store;
  }

  /// Initializes the [UserStore] instance from json data.
  ///
  /// [update] field defines whether we should call API to update the user data
  /// or not.
  factory UserStore.fromJson(
      {required Map<String, dynamic> json, bool update = true}) {
    return UserStore.fromUser(user: User.fromJson(json), update: update);
  }

  /// Initializes the UserStore from json string data.
  ///
  /// [update] field defines whether we should call API to update the user data
  /// or not.
  factory UserStore.fromJsonString({required String json, bool update = true}) {
    return UserStore.fromJson(json: jsonDecode(json));
  }

  /// Initializes the organization store for current user.
  late final organizations = OrganizationListStore(user: this);

  /// Loads user data from API.
  Future<void> loadUserData({bool force = false}) async {
    if (token.isEmpty) return;

    await networkCall(() async {
      if (user != null && !force) return;
      user = (await ApiRepository.instance.getUser(token: token));
      user!.saveToPreferences();
    });
  }
}

abstract class _UserStore extends NetworkStore with Store {
  _UserStore({required this.token});

  /// Saves the user's token that will be used to make all the API calls.
  late final String token;

  @observable

  /// Saves all the data for current user.
  User? user;
}
