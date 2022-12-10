part of 'interceptors.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfigs.users.currentUser == null) {
      handler.reject(DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 401,
          statusMessage: 'No user selected.',
          data: {
            'error': {
              'code': 'Unauthorized Access',
              'message': 'No user selected.'
            }
          },
        ),
      ));
    }

    if (!options.headers.containsKey(kAuthHeaderKey)) {
      options.headers.addAll({
        kAuthHeaderKey: AppConfigs.users.currentUser!.token,
      });
    }

    handler.next(options);
  }
}
