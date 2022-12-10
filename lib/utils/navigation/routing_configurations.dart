import 'package:app_center_agent/app_configs.dart';
import 'package:app_center_agent/models/search_models/search_application_data.dart';
import 'package:app_center_agent/models/search_models/search_distribution_group_data.dart';
import 'package:app_center_agent/models/search_models/search_organization_data.dart';
import 'package:app_center_agent/models/search_models/search_release_data.dart';
import 'package:app_center_agent/modules/app_center_app/app_center_app_details_screen.dart';
import 'package:app_center_agent/modules/download_list_screen/download_list_screen.dart';
import 'package:app_center_agent/modules/group/app_center_group_details_screen.dart';
import 'package:app_center_agent/modules/organization/organization_details_screen.dart';
import 'package:app_center_agent/modules/page_not_found_screen.dart';
import 'package:app_center_agent/modules/release_details/app_center_release_details_screen.dart';
import 'package:app_center_agent/modules/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;

import '../../modules/home/home_screen.dart';
import '../../modules/login/login_screen.dart';

part 'route_data.dart';

class RoutingConfigurations {
  static final GoRouter router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    initialLocation: AppRouteData.splash.path,
    routes: [
      GoRoute(
        path: AppRouteData.home.path,
        name: AppRouteData.home.name,
        builder: (_, __) => const HomeScreen(),
        routes: [
          GoRoute(
            path: AppRouteData.organizationDetails.path,
            name: AppRouteData.organizationDetails.name,
            builder: (_, state) {
              final name = state.pathParameters[ParamName.orgName];

              final org = (name?.isNotEmpty ?? false)
                  ? AppConfigs.users.currentUser?.organizations
                      .getOrganizationByName(
                      request: SearchOrganizationData(
                        organization: name!,
                      ),
                    )
                  : null;

              return OrganizationDetailsScreen(store: org);
            },
            routes: [
              GoRoute(
                path: AppRouteData.applicationDetails.path,
                name: AppRouteData.applicationDetails.name,
                builder: (_, state) {
                  final orgName = state.pathParameters[ParamName.orgName];
                  final appName = state.pathParameters[ParamName.appName];

                  final app = (orgName?.isNotEmpty ?? false) &&
                          (appName?.isNotEmpty ?? false)
                      ? AppConfigs.users.currentUser?.organizations
                          .getApplicationByName(
                          request: SearchApplicationData(
                            organization: orgName!,
                            app: appName!,
                          ),
                        )
                      : null;

                  return AppCenterAppDetailsScreen(store: app);
                },
                routes: [
                  GoRoute(
                    path: AppRouteData.groupDetails.path,
                    name: AppRouteData.groupDetails.name,
                    builder: (_, state) {
                      final orgName = state.pathParameters[ParamName.orgName];
                      final appName = state.pathParameters[ParamName.appName];
                      final groupName =
                          state.pathParameters[ParamName.groupName];

                      final group = (orgName?.isNotEmpty ?? false) &&
                              (appName?.isNotEmpty ?? false) &&
                              (groupName?.isNotEmpty ?? false)
                          ? AppConfigs.users.currentUser?.organizations
                              .getDistributionGroup(
                              request: SearchDistributionGroupData(
                                group: groupName!,
                                app: appName!,
                                organization: orgName!,
                              ),
                            )
                          : null;

                      return AppCenterGroupDetailsScreen(store: group);
                    },
                    routes: [
                      GoRoute(
                          path: AppRouteData.releaseDetails.path,
                          name: AppRouteData.releaseDetails.name,
                          builder: (_, state) {
                            final orgName =
                                state.pathParameters[ParamName.orgName];
                            final appName =
                                state.pathParameters[ParamName.appName];
                            final groupName =
                                state.pathParameters[ParamName.groupName];
                            final releaseId = int.tryParse(
                                    state.pathParameters[ParamName.releaseId] ??
                                        '') ??
                                -1;

                            final release = (orgName?.isNotEmpty ?? false) &&
                                    (appName?.isNotEmpty ?? false) &&
                                    (groupName?.isNotEmpty ?? false) &&
                                    releaseId > 0
                                ? AppConfigs.users.currentUser?.organizations
                                    .getReleaseById(
                                    request: SearchReleaseData(
                                      releaseId: releaseId,
                                      group: groupName!,
                                      app: appName!,
                                      organization: orgName!,
                                    ),
                                  )
                                : null;

                            return AppCenterReleaseDetailsScreen(
                              store: release,
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRouteData.downloadsList.path,
            name: AppRouteData.downloadsList.name,
            builder: (_, __) => const DownloadListScreen(),
          ),
        ],
      ),
      GoRoute(
          path: AppRouteData.splash.path,
          name: AppRouteData.splash.name,
          builder: (_, __) {
            return const SplashScreen();
          }),
      GoRoute(
        path: AppRouteData.login.path,
        name: AppRouteData.login.name,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRouteData.pageNotFound.path,
        name: AppRouteData.pageNotFound.name,
        builder: (_, __) => const PageNotFoundScreen(),
      ),
    ],
    redirect: (_, state) {
      if (state.matchedLocation == AppRouteData.splash.path) {
        return state.path;
      }

      if (state.matchedLocation != AppRouteData.login.path &&
          (AppConfigs.users.users.isEmpty)) {
        return AppRouteData.login.path;
      }

      return state.path;
    },
  );
}
