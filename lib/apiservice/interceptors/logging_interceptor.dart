// ignore_for_file: empty_catches
part of 'interceptors.dart';

// NOTE: we are using assert to print the data. because logs should be
// displayed only in debug mode. In release mode, even though we are not
// printing the message, It still does all the operations to convert the
// response and request to string. If there is any error in conversion,
// it will cause issue in production release as well which should not happen.
//
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    proxyAssert(() {
      try {
        final log = '\nflutter: --------------------------------------------\n'
            '                      REQUEST\n'
            '-----------------------------------------------------\n'
            ':: Auth Token    - ${options.headers[kAuthHeaderKey]}\n'
            ':: Method        - ${options.method.toUpperCase()}\n'
            ':: Request URL   - ${options.uri}\n'
            ':: Parameters    - ${options.queryParameters}\n'
            ':: Body          - ${options.data}\n'
            ':: Content Type  - ${options.contentType}\n'
            ':: UTC Time      - ${DateTime.now().toUtc().toString()}\n'
            '-----------------------------------------------------\n'
            '------------------------ END ------------------------\n'
            '-----------------------------------------------------\n';
        debugPrint(log);
      } catch (e) {}
    });
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    proxyAssert(() {
      try {
        final log = '\nflutter: --------------------------------------------\n'
            '                  SUCCESS RESPONSE\n'
            '-----------------------------------------------------\n'
            ':: Status Code   - ${response.statusCode}\n'
            ':: Response Body  - ${response.data}\n'
            '-----------------------------------------------------\n'
            '--------------- REQUEST DATA ------------------------\n'
            '-----------------------------------------------------\n'
            ':: Auth token    - '
            '${response.requestOptions.headers[kAuthHeaderKey]}\n'
            ':: Request URL   - ${response.requestOptions.uri}\n'
            ':: Parameters    - ${response.requestOptions.queryParameters}\n'
            ':: Request Body  - ${response.requestOptions.data}\n'
            ':: Content Type  - ${response.requestOptions.contentType}\n'
            ':: UTC Time      - ${DateTime.now().toUtc().toString()}\n'
            '-----------------------------------------------------\n'
            '------------------------ END ------------------------\n'
            '-----------------------------------------------------\n';
        debugPrint(log);
      } catch (e) {}
    });
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    proxyAssert(() {
      try {
        final log = '\n-----------------------------------------------------\n'
            '                   ERROR RESPONSE\n'
            '-----------------------------------------------------\n'
            ':: Status Code   - ${err.response?.statusCode}\n'
            ':: Error Message - ${err.message}\n'
            ':: Request Body  - ${err.response?.data}\n'
            '-----------------------------------------------------\n'
            '--------------- REQUEST DATA ------------------------\n'
            '-----------------------------------------------------\n'
            ':: Auth Token    - '
            '${err.requestOptions.headers[kAuthHeaderKey]}\n'
            ':: Request URL   - ${err.requestOptions.uri}\n'
            ':: Parameters    - ${err.requestOptions.queryParameters}\n'
            ':: Request Body  - ${err.requestOptions.data}\n'
            ':: Content Type  - ${err.requestOptions.contentType}\n'
            ':: UTC Time      - ${DateTime.now().toUtc().toString()}\n'
            '-----------------------------------------------------\n'
            '------------------------ END ------------------------\n'
            '-----------------------------------------------------\n';
        debugPrint(log);
      } catch (e) {}
    });
    handler.reject(err);
  }
}
