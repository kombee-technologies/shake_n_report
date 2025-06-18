import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shake_n_report/shake_to_report.dart';
import 'package:shake_n_report/src/core/di.dart';
import 'package:toastification/toastification.dart';

class Utility {
  static final Logger _logger = Logger();

  /// Log an informational message
  static void infoLog(String log) {
    if (ShakeToReportPlugin.instance.isDebuggable) {
      _logger.i(log);
    }
  }

  /// Log a warning message
  static void warnLog(String log) {
    if (ShakeToReportPlugin.instance.isDebuggable) {
      _logger.w(log);
    }
  }

  /// Log an error message
  // ignore: avoid_annotating_with_dynamic
  static void errorLog(String log, [dynamic error, StackTrace? stackTrace]) {
    if (ShakeToReportPlugin.instance.isDebuggable) {
      _logger.e(log, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a debug message
  static void debugLog(String log) {
    if (ShakeToReportPlugin.instance.isDebuggable) {
      _logger.d(log);
    }
  }

  /// Log a verbose message
  static void verboseLog(String log) {
    if (ShakeToReportPlugin.instance.isDebuggable) {
      _logger.t(log);
    }
  }

  /// Log a message with a custom level
  static void log(Level level, String log) {
    if (ShakeToReportPlugin.instance.isDebuggable) {
      _logger.log(level, log);
    }
  }

  static void showSnackbar({required String msg, BannerStyle? bannerStyle, void Function()? onTap}) {
    getIt<Toastification>().dismissAll();
    final ToastificationType toastificationType;
    if (bannerStyle == BannerStyle.success) {
      toastificationType = ToastificationType.success;
    } else if (bannerStyle == BannerStyle.error) {
      toastificationType = ToastificationType.error;
    } else if (bannerStyle == BannerStyle.warning) {
      toastificationType = ToastificationType.warning;
    } else {
      toastificationType = ToastificationType.info;
    }
    getIt<Toastification>().show(
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      description: Text(
        msg,
      ),
      type: toastificationType,
    );
  }
}
