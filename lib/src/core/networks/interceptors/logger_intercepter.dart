import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

/// [LoggingInterceptor] is used to print logs during network requests.
/// It's better to add [LoggingInterceptor] to the tail of the interceptor queue,
/// otherwise the changes made in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor();

  @override
  Future<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    logPrint('*************** API Request - Start ***************');

    printKV('URI', options.uri);
    printKV('METHOD', options.method);
    logPrint('HEADERS:');
    // ignore: avoid_annotating_with_dynamic
    options.headers.forEach((String key, dynamic v) => printKV(' - $key', v));
    logPrint('BODY:');
    printAll(options.data.toString());

    logPrint('*************** API Request - End ***************');

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logPrint('*************** Api Error - Start ***************:');

    logPrint('URI: ${err.requestOptions.uri}');
    if (err.response != null) {
      logPrint('STATUS CODE: ${err.response?.statusCode?.toString()}');
    }
    logPrint('$err');
    if (err.response != null) {
      printKV('REDIRECT', err.response?.realUri ?? '');
      logPrint('BODY:');
      printAll(jsonEncode(err.response?.data));
    }

    logPrint('*************** Api Error - End ***************:');
    return handler.next(err);
  }

  @override
  Future<dynamic> onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) async {
    logPrint('*************** Api Response - Start ***************');

    printKV('URI', response.requestOptions.uri);
    printKV('STATUS CODE', response.statusCode ?? '');
    printKV('REDIRECT', response.isRedirect);
    printKV('STATUS MSG', response.statusMessage ?? '');
    logPrint('BODY:');
    printAll(jsonEncode(response.data));

    logPrint('*************** Api Response - End ***************');

    return handler.next(response);
  }

  // ignore: avoid_annotating_with_dynamic
  void printKV(String key, dynamic v) {
    logPrint('$key: $v');
  }

  void printAll(String msg) {
    // msg.toString().split('\n').forEach(logPrint);
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(msg)
        .forEach((RegExpMatch match) => logPrint(match.group(0) ?? ''));
  }

  void logPrint(String s) {
    debugPrint(s, wrapWidth: 500);
  }
}
