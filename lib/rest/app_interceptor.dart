import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppInterceptor extends Interceptor {
  const AppInterceptor(this.ref);
  final Ref ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Access-Control-Allow-Origin'] = true;
    options.headers['Content-Type'] = 'application/json';


    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode;
    if (status != null && status != 200) {
      print('##onResponse: ${response.data}');
      handler.reject(DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data['message'] as String? ?? 'ErrorPageMessage',
        type: DioExceptionType.badResponse,
      ));
    } else {
      if (response.data is String) {
        try {
          response.data = jsonDecode(response.data);
        } catch (e) {
          handler.reject(DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Invalid JSON format',
            type: DioExceptionType.badResponse,
          ));
          return;
        }
      }
      handler.next(response);
    }
  }


  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 404) {
      handler.reject(DioException(
        requestOptions: err.requestOptions,
        type: DioExceptionType.unknown,
        error: "User not found",
      ));
      return;
    } else if (err.type == DioExceptionType.connectionError ||
        err.error is SocketException) {
      if (kDebugMode) {
        print('## No internet connection detected');
      }

      // You can pass a custom error message
      handler.reject(DioException(
        requestOptions: err.requestOptions,
        type: DioExceptionType.unknown,
        error: 'No internet connection. Please check your network.',
      ));
      return;
    }

    handler.next(err);
  }

  Future<Response<dynamic>> retryRequest(RequestOptions options) async {
    options.headers['Access-Control-Allow-Origin'] = true;
    options.headers['Content-Type'] = 'application/json';

    final dio = Dio(
      BaseOptions(
        baseUrl: options.baseUrl,
        connectTimeout: options.connectTimeout,
        receiveTimeout: options.receiveTimeout,
        headers: options.headers,
      ),
    );

    return dio.request(
      options.path,
      data: options.data,
      options: Options(method: options.method),
    );
  }

}
