import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:shake_n_report/shake_n_report.dart';

class Utility {
  static final String _tag = 'ShakeNReport';

  /// Log an informational message
  static void infoLog(String log) {
    if (ShakeNReportPlugin.instance.isDebuggable) {
      dev.log(_tag + log);
    }
  }

  /// Show a snackbar message using Flutter's built-in SnackBar
  ///
  /// [msg] - The message to display
  /// [bannerStyle] - The style of the banner (success, error, warning, info)
  /// [onTap] - Optional callback when the snackbar is tapped
  static void showSnackbar({
    required String msg,
    BannerStyle? bannerStyle,
    void Function()? onTap,
  }) {
    final BuildContext? context =
        ShakeNReportPlugin.instance.navigatorKey.currentContext;

    if (context == null || !context.mounted) {
      return;
    }

    // Dismiss any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    // Determine background color based on banner style
    Color backgroundColor;
    final Color textColor = Colors.white;
    IconData icon;

    switch (bannerStyle) {
      case BannerStyle.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case BannerStyle.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case BannerStyle.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
      case BannerStyle.info:
        backgroundColor = Colors.blue;
        icon = Icons.info;
        break;
      case null:
        backgroundColor = Colors.blue;
        icon = Icons.info;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        action: onTap != null
            ? SnackBarAction(
                label: 'Action',
                textColor: textColor,
                onPressed: onTap,
              )
            : null,
      ),
    );
  }
}
