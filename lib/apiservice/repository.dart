import 'package:app_center_agent/apiservice/apiservice.dart';
import 'package:app_center_agent/apiservice/interceptors/interceptors.dart';
import 'package:app_center_agent/models/organization_list_response.dart';
import 'package:app_center_agent/stores/organization_store.dart';
import 'package:dio/dio.dart';

import '../stores/user_store.dart';

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

  Future<List<OrganizationResponse>> getOrganizationList({String? token}) {
    return _apiCall<List<OrganizationResponse>>(
      () async => await _service.getAllOrganizations(auth: token),
    );
  }

  Future<OrganizationModel> getOrganization(
      {required String name, String? token}) {
    return _apiCall<OrganizationModel>(
      () async => await _service.getOrganization(name: name, auth: token),
    );
  }

  Future<T> _apiCall<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioError catch (e) {
      if (e.response == null) {
        throw 'No internet connection. Please make sure you '
            'are connected with internet.';
      }
      if (e.type == DioErrorType.sendTimeout) {
        throw 'Slow internet. Please make sure you are '
            'connected to proper network connection.';
      }

      throw 'Something went wrong';
    }
  }
}
