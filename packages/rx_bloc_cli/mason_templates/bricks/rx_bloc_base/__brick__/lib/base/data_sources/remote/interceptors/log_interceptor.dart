import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LogInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestDetails =
        '[${response.statusCode}] [${response.requestOptions.method}] ${response.requestOptions.uri}';
    debugPrint('$requestDetails \n${response.toString()}');
    handler.next(response);
  }
}
