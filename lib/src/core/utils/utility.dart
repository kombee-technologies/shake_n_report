import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:shake_n_report/shake_n_report.dart';
import 'package:shake_n_report/src/core/di.dart';
import 'package:toastification/toastification.dart';

class Utility {
  static final String _tag = 'ShakeNReport';

  /// Log an informational message
  static void infoLog(String log) {
    if (ShakeNReportPlugin.instance.isDebuggable) {
      dev.log(_tag + log);
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
