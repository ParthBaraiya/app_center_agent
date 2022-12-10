part of 'interceptors.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (UserAccountListStore.instance.currentUser == null) {
      handler.reject(DioError(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 401,
          statusMessage: 'No user selected.',
          data: {
            "error": {
              "code": "Unauthorized Access",
              "message": "No user selected."
            }
          },
        ),
      ));
    }

    if (!options.headers.containsKey(kAuthHeaderKey)) {
      options.headers.addAll({
        kAuthHeaderKey: UserAccountListStore.instance.currentUser!.token,
      });
    }

    handler.next(options);
  }
}
