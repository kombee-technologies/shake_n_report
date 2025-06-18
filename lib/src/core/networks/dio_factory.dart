import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shake_n_report/src/core/networks/interceptors/exceptions_interceptor.dart';
import 'package:shake_n_report/src/core/networks/interceptors/logger_intercepter.dart';

// in seconds
const int connectionTimeout = 60;
const int sendTimeout = 60;
const int receiveTimeout = 60;

class DioFactory {
  final Dio _dio = Dio(BaseOptions(
    // baseUrl: AppConstants.baseUrlSchema,
    connectTimeout: const Duration(seconds: connectionTimeout),
    sendTimeout: const Duration(seconds: sendTimeout),
    receiveTimeout: const Duration(seconds: receiveTimeout),
    contentType: Headers.jsonContentType,
  ));

  Dio get shared => _dio;

  DioFactory() {
    _addDioInterceptors();
  }

  void _addDioInterceptors() {
    _dio.interceptors.addAll(<Interceptor>[
      ExceptionsInterceptor(),
      if (kDebugMode) LoggingInterceptor(),
    ]);
  }
}
