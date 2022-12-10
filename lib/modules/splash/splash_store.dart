import 'package:app_center_agent/app_configs.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:app_center_agent/utils/navigation/routing_configurations.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

part 'splash_store.g.dart';

class SplashStore = _SplashStore with _$SplashStore;

abstract class _SplashStore extends NetworkStore with Store {
  Future<void> init() async {
    if (state.isLoading) return;

    state = NetworkState.loading;

    try {
      await AppConfigs.init();
      state = NetworkState.success;
      RoutingConfigurations.router.routerDelegate.navigatorKey.currentContext
          ?.goNamed(AppRouteData.home.name);
    } catch (e) {
      state = NetworkState.error;
      error = 'Something went wrong!';
    }
  }
}
