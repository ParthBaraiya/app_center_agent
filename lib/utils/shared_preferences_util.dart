import 'dart:convert';

import 'package:app_center_agent/stores/user_store.dart';
import 'package:app_center_agent/values/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtility {
  SharedPreferencesUtility._();

  static Future<bool> saveUser({required User user}) async {
    if (user.authToken.isEmpty) throw AppStrings.invalidAuthToken;

    final sp = await SharedPreferences.getInstance();
    final key = SharedPreferencesKeys.userDataKey(user.authToken);

    final data = sp.getString(key);

    var response = await sp.setString(
        SharedPreferencesKeys.userDataKey(user.authToken),
        jsonEncode(user.toJson()));

    if (data == null) {
      response &= await sp.setStringList(
          SharedPreferencesKeys.tokens,
          (sp.getStringList(SharedPreferencesKeys.tokens) ?? [])
            ..add(user.authToken));
    }

    return response;
  }

  static Future<Map<String, UserStore>> getStoredUsers() async {
    final sp = await SharedPreferences.getInstance();
    final tokens = sp.getStringList(SharedPreferencesKeys.tokens) ?? [];
    debugPrint("${tokens.length} users found...");
    final users = <String, UserStore>{};
    for (final token in tokens) {
      try {
        final data = sp.getString(SharedPreferencesKeys.userDataKey(token));
        if (data == null) continue;

        if (users[token] == null) {
          final user = UserStore.fromJsonString(json: data, update: false);

          users.addAll({
            token: user,
          });
        }
      } catch (e, stack) {
        debugPrint('Can not parse data from shared preferences.');
        debugPrint('$e');
        debugPrintStack(stackTrace: stack);
      }
    }
    return users;
  }

  // static Future<bool> setToken({required String token}) async {
  //   final sp = await SharedPreferences.getInstance();
  //   return await sp.setString(SharedPreferencesKeys.token, token);
  // }
  //
  // static Future<String?> getToken() async {
  //   final sp = await SharedPreferences.getInstance();
  //
  //   return sp.getString(SharedPreferencesKeys.token);
  // }
  //
  // static Future<bool> removeToken() async {
  //   final sp = await SharedPreferences.getInstance();
  //
  //   return await sp.remove(SharedPreferencesKeys.token);
  // }
}

class SharedPreferencesKeys {
  SharedPreferencesKeys._();

  static const tokens = 'tokens';
  static const userDataPrefix = 'user-data-';
  static String userDataKey(String token) => '$userDataPrefix$token';
}
