import 'package:app_center_agent/stores/user_account_list_store.dart';
import 'package:go_router/go_router.dart';

import '../../modules/home/home_page.dart';
import '../../modules/login/login_page.dart';

part 'route_data.dart';

class RoutingConfigurations {
  static final GoRouter router = GoRouter(
    initialLocation: RouteData.home.path,
    routes: [
      GoRoute(
        path: RouteData.home.path,
        name: RouteData.home.name,
        builder: (_, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteData.login.path,
        name: RouteData.login.name,
        builder: (_, __) => const LoginPage(),
      ),
    ],
    redirect: (_, state) {
      if ((state.name == null || state.name != RouteData.login.name) &&
          UserAccountListStore.instance.users.isEmpty) {
        return RouteData.login.path;
      }

      return state.path;
    },
  );
}
