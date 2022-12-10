import 'package:app_center_agent/stores/user_account_list_store.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:app_center_agent/utils/navigation/routing_configurations.dart';
import 'package:app_center_agent/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  _LoginStore({required this.buildContext});

  @observable
  bool isLoading = false;

  final BuildContext buildContext;

  final formKey = GlobalKey<FormState>();
  String _token = '';

  Future<void> submit() async {
    if (isLoading) return;

    isLoading = true;
    formKey.currentState?.save();

    if ((formKey.currentState?.validate() ?? false) && _token.isNotEmpty) {
      final controller = buildContext.showSnackBar(
        message: 'Please wait...',
        duration: const Duration(days: 1000),
      );

      try {
        UserAccountListStore.instance.addUserByToken(_token);
        buildContext.goNamed(RouteData.home.name);
        controller.close();
      } catch (e) {
        buildContext.showSnackBar(message: AppStrings.somethingWentWrong);
      }
    } else {
      buildContext.showSnackBar(message: 'Token can not be empty');
    }

    isLoading = false;
  }

  String? validate(String? token) {
    if (token == null || token.isEmpty) {
      return 'Please enter valid token';
    }

    return null;
  }

  void onSaved(String? token) => _token = token ?? _token;
}
