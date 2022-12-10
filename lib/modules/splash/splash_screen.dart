import 'package:app_center_agent/modules/splash/splash_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:app_center_agent/widgets/data_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final store = SplashStore();

  @override
  void initState() {
    super.initState();

    store.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          return Center(
            child: DataPlaceholder(
              state: store.state,
              placeholderDataMap: {
                NetworkState.loading: const NetworkStatePlaceholderData(
                  title: 'Initializing App',
                  subTitle: 'Please wait while we initialize the app for you!',
                ),
                NetworkState.success: const NetworkStatePlaceholderData(
                  title: 'App Initialized',
                  subTitle: 'You will be navigated to home screen soon',
                ),
                NetworkState.error: NetworkStatePlaceholderData(
                  title: 'Oops!',
                  subTitle: store.error ?? 'Something went wrong!',
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
