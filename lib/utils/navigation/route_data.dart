part of 'routing_configurations.dart';

enum AppRouteData {
  /// Usage:
  ///
  /// context.goNamed([AppRouteData.home.organization])
  ///
  home(path: '/', name: 'home'),
  splash(path: '/splash', name: 'Splash'),

  /// Usage:
  ///
  /// ```dart
  /// context.goNamed([RouteData.login.name])
  /// ```
  ///
  login(path: '/login', name: 'login'),

  /// Usage:
  ///
  /// ```dart
  /// context.goNamed(RouteData.pageNotFound.name)
  /// ```
  ///
  pageNotFound(path: '/404', name: 'page not found'),

  /// Usage:
  ///
  /// ```dart
  /// context.goNamed(
  ///   RouteData.organizationDetails.name,
  ///   params: {
  ///     'name': organization name,
  ///   },
  /// )
  /// ```
  ///
  organizationDetails(
    path: 'org/:${ParamName.orgName}',
    name: 'organization details',
    parent: AppRouteData.home,
  ),
  applicationDetails(
    path: 'app/:${ParamName.appName}',
    name: 'app details',
    parent: AppRouteData.organizationDetails,
  ),
  groupDetails(
    path: 'group/:${ParamName.groupName}',
    name: 'group details',
    parent: AppRouteData.applicationDetails,
  ),
  releaseDetails(
    path: 'release/:${ParamName.releaseId}',
    name: 'release details',
    parent: AppRouteData.groupDetails,
  ),
  downloadsList(
    path: 'download_list',
    name: 'downloads list',
    parent: AppRouteData.home,
  );

  final String name;
  final String path;
  final AppRouteData? parent;

  const AppRouteData({
    required this.path,
    required this.name,
    this.parent,
  });

  String get fullPath => p.join(parent?.path ?? '/', path);
}

abstract class ParamName {
  static const orgName = 'org_name';
  static const appName = 'app_name';
  static const groupName = 'group_name';
  static const releaseId = 'release_id';
}
