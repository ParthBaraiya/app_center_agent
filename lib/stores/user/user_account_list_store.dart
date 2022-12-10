import 'package:app_center_agent/app_configs.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/utils/shared_preferences_util.dart';
import 'package:mobx/mobx.dart';

import 'user_store.dart';

part 'user_account_list_store.g.dart';

/// A global store to save all the user's data.
/// NOTE: Do not create the instance of this class separately,
/// Instead, use [AppConfigs] to access the already created instance.
///
class UsersListStore = _UsersListStore with _$UsersListStore;

abstract class _UsersListStore extends NetworkStore with Store {
  /// Stores all the users in the list.
  final users = ObservableMap<String, UserStore>.of({});

  @observable

  /// Gives the reference of the current user.
  ///
  /// If the reference is null, that means, no users are logged in and
  /// app should be navigated to the login screen.
  ///
  UserStore? currentUser;

  /// Loads all the users from shared preferences.
  ///
  Future<void> loadDataFromSharedPreferences() async {
    return networkCall(() async {
      final response = await SharedPreferencesUtility.getStoredUsers();

      users.clear();
      users.addAll(response);

      if (users.isNotEmpty) {
        currentUser = users.values.first;
        currentUser?.loadUserData();
      }
    });
  }

  /// Adds new user using auth token.
  ///
  void addUserByToken(String token) {
    if (users[token] == null) {
      users.addAll({
        token: UserStore(token: token),
      });
    } else {
      users[token]!.loadUserData();
    }

    setUser(users[token]!);
  }

  /// Sets current active user from the list of users.
  ///
  void setUser(UserStore user) {
    final u = users[user.token];
    if (u != null) {
      currentUser = u;
      currentUser?.loadUserData();
    }
  }
}
