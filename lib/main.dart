import 'package:app_center_agent/app_configs.dart';
import 'package:app_center_agent/utils/navigation/routing_configurations.dart';
import 'package:app_center_agent/values/constants.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
    AppConfigs.instance?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppConstants.roboto,
        fontWeight: FontWeight.w700,
        fontSize: 36,
      ),
      displayMedium: TextStyle(
        fontFamily: AppConstants.roboto,
        fontWeight: FontWeight.w700,
        fontSize: 28,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppConstants.roboto,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      headlineSmall: TextStyle(
        fontSize: 14,
      ),
      titleLarge: TextStyle(
        fontSize: 12,
      ),
    );
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: AppConstants.aBeeZee,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 30),
        ),
        textTheme: textTheme,
        visualDensity: VisualDensity.comfortable,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: AppConstants.aBeeZee,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 30),
        ),
        textTheme: textTheme,
      ),
      themeMode: ThemeMode.light,
      routerConfig: RoutingConfigurations.router,
    );
  }
}
