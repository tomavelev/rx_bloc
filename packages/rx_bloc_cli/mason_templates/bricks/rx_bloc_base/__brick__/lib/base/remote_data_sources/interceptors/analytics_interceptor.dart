// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';

/// Interceptors are a simple way to intercept and modify http requests globally
/// before they are sent to the server. That allows us to configure
/// authentication tokens, add logs of the requests,
/// add custom headers and much more.
/// Interceptors can perform a variety of implicit tasks, from authentication
/// to logging, for every HTTP request/response. Without interception, we will
/// have to implement these tasks explicitly for each HttpClient method call.
class AnalyticsInterceptor extends Interceptor{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
  }

}