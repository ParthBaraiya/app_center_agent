import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../utils/enums.dart';
import '../values/app_strings.dart';

part 'network_store.g.dart';

class NetworkStore = _NetworkStore with _$NetworkStore;

abstract class _NetworkStore with Store {
  @observable
  NetworkState networkState = NetworkState.idle;

  @observable
  String? networkError;

  Future<void> networkCall(AsyncCallback callback) async {
    if (networkState.isLoading) return;

    networkState = NetworkState.loading;

    try {
      await callback();
      networkState = NetworkState.success;
    } on String catch (e) {
      networkError = e;
      networkState = NetworkState.error;
    } catch (e) {
      networkError = AppStrings.somethingWentWrong;
      networkState = NetworkState.error;
    }
  }
}
