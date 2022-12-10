import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../utils/enums.dart';
import '../values/app_strings.dart';

part 'network_store.g.dart';

class NetworkStore = _NetworkStore with _$NetworkStore;

abstract class _NetworkStore with Store {
  @observable
  NetworkState state = NetworkState.idle;

  @observable
  String? error;

  Future<void> networkCall(AsyncCallback callback) async {
    if (state.isLoading) return;

    state = NetworkState.loading;

    try {
      await callback();
      state = NetworkState.success;
    } on String catch (e) {
      error = e;
      state = NetworkState.error;
    } catch (e) {
      error = AppStrings.somethingWentWrong;
      state = NetworkState.error;
    }
  }
}
