import 'package:app_center_agent/apiservice/apiservice.dart';
import 'package:app_center_agent/apiservice/interceptors/interceptors.dart';
import 'package:app_center_agent/models/app_center_release.dart';
import 'package:app_center_agent/models/appcenter_application.dart';
import 'package:app_center_agent/models/distribution_groups.dart';
import 'package:app_center_agent/models/organization.dart';
import 'package:app_center_agent/models/user.dart';
import 'package:dio/dio.dart';

// 824ed7c91d77a75ca579980241980630c2f20a2a

class ApiRepository {
  static final instance = ApiRepository._();
  ApiRepository._() {
    final dio = Dio();
    dio.interceptors.add(AuthInterceptor());

    // Add logger in
    assert(() {
      dio.interceptors.add(LoggingInterceptor());
      return true;
    }());
    _service = ApiService(dio);
  }

  late final ApiService _service;

  Future<User> getUser({required String token}) {
    return _apiCall<User>(() async {
      return (await _service.getUser(auth: token)).updateToken(token);
    });
  }

  Future<List<AppCenterApplication>> getAllAppsForUser(
      {required String token}) {
    return _apiCall(() async {
      return (await _service.getAllAppsForUser(auth: token));
    });
  }

  Future<List<Organization>> getOrganizationList({String? token}) {
    return _apiCall<List<Organization>>(
      () => _service.getAllOrganizations(auth: token),
    );
  }

  Future<OrganizationDetails> getOrganization(
      {required String name, String? token}) {
    return _apiCall<OrganizationDetails>(
      () => _service.getOrganization(name: name, auth: token),
    );
  }

  // NOTE: This endpoint is not working for all organizations.
  // Future<List<AppCenterApplication>> getAppsListForOrganization(
  //     {required String name, String? token}) {
  //   return _apiCall<List<AppCenterApplication>>(
  //     () => _service.getAppsListForOrganization(name: name, auth: token),
  //   );
  // }

  Future<List<AppCenterGroup>> getDistributionGroupsForApp({
    required String appOwnerName,
    required String appName,
    String? token,
  }) {
    return _apiCall(() => _service.getDistributionGroupsForApp(
          appName: appName,
          appOwnerName: appOwnerName,
          auth: token,
        ));
  }

  Future<List<AppCenterRelease>> getAppRelease({
    required String owner,
    required String app,
    required String group,
    String? token,
  }) {
    return _apiCall(() => _service.getAppRelease(
          app: app,
          owner: owner,
          group: group,
          auth: token,
        ));
  }

  Future<AppCenterReleaseDetails> getAppReleaseDetails({
    required String owner,
    required String app,
    required String group,
    required int releaseId,
    String? token,
  }) {
    return _apiCall(() => _service.getAppReleaseDetails(
          app: app,
          owner: owner,
          group: group,
          releaseId: releaseId,
          auth: token,
        ));
  }

  Future<T> _apiCall<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (e.response == null) {
        throw 'No internet connection. Please make sure you '
            'are connected with internet.';
      }
      if (e.type == DioExceptionType.sendTimeout) {
        throw 'Slow internet. Please make sure you are '
            'connected to proper network connection.';
      }

      throw 'Something went wrong';
    }
  }
}
