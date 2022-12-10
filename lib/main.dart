import 'package:app_center_agent/stores/user_account_list_store.dart';
import 'package:app_center_agent/utils/navigation/routing_configurations.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserAccountListStore.instance.loadDataFromSharedPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 30),
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 30),
        ),
      ),
      themeMode: ThemeMode.light,
      routerConfig: RoutingConfigurations.router,
    );
  }
}
