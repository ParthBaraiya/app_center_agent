part of 'interceptors.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
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
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final log = '\nflutter: --------------------------------------------\n'
        '                  SUCCESS RESPONSE\n'
        '-----------------------------------------------------\n'
        ':: Status Code   - ${response.statusCode}\n'
        ':: Request Body  - ${response.data}\n'
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
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
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
    handler.reject(err);
  }
}
