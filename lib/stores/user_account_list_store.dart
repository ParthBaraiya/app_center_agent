import 'package:app_center_agent/utils/shared_preferences_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import 'user_store.dart';

part 'user_account_list_store.g.dart';

class UserAccountListStore extends _UserAccountListStore
    with _$UserAccountListStore {
  static final instance = UserAccountListStore._();
  UserAccountListStore._();

  Future<void> loadDataFromSharedPreferences() async {
    try {
      final response = await SharedPreferencesUtility.getStoredUsers();

      users.clear();
      users.addAll(response);

      if (users.isNotEmpty) {
        currentUser = users.values.first;
        currentUser?.loadUserData();
      }
    } catch (e, stack) {
      debugPrint('Error while adding new users');
      debugPrint('$e');
      debugPrintStack(stackTrace: stack);
    }
  }
}

abstract class _UserAccountListStore with Store {
  final users = ObservableMap<String, UserStore>.of({});

  @observable
  UserStore? currentUser;

  void addUserByToken(String token) {
    if (users[token] == null) {
      users.addAll({
        token: UserStore(token: token),
      });
    } else {
      users[token]!.loadUserData();
    }
  }

  void setUser(UserStore user) {
    final u = users[user.token];
    if (u != null) {
      currentUser = u;
      currentUser?.loadUserData();
    }
  }
}
