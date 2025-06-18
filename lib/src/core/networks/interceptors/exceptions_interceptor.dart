import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shake_n_report/src/core/constants/my_constants.dart';
import 'package:shake_n_report/src/core/di.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';

class ExceptionsInterceptor extends InterceptorsWrapper {
  ExceptionsInterceptor();

  final LocalStorage _localStorage = getIt<LocalStorage>();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      debugPrint('DioFactory >> onError: $err');
    }
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: TimeoutException(MyConstants.connectionTimeout),
        ));
        break;
      case DioExceptionType.badCertificate:
        handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: BadCertificateException(MyConstants.badCertificate),
        ));
        break;
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 401:
          case 403:
            await _localStorage.clear();
            handler.reject(DioException(
              requestOptions: err.requestOptions,
              error: UnauthorizedException(MyConstants.unauthorizedAccess),
            ));
            break;
          case 404:
            handler.reject(DioException(
              requestOptions: err.requestOptions,
              error: RouteNotFoundException(MyConstants.routeNotFound),
            ));
            break;
          default:
            handler.reject(DioException(
              requestOptions: err.requestOptions,
              error: ServerException(MyConstants.somethingWentWrong),
            ));
            break;
        }
        break;
      case DioExceptionType.cancel:
        handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: RequestCancelledException(MyConstants.requestCancelled),
        ));
        break;
      case DioExceptionType.connectionError:
        handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: ConnectionErrorException(MyConstants.connectionError),
        ));
        break;
      case DioExceptionType.unknown:
        handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: GeneralException(MyConstants.somethingWentWrong),
        ));
        break;
      // default:
      //   handler.reject(DioException(
      //     requestOptions: e.requestOptions,
      //     error: GeneralException(MyConstants.somethingWentWrong ),
      //   ));
      //   break;
    }
  }
}
