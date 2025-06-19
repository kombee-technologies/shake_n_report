import 'package:flutter/material.dart';
import 'package:shake_n_report/src/core/constants/enums.dart';
import 'package:shake_n_report/src/core/di.dart';
import 'package:shake_n_report/src/data/models/jira/jira_config.dart';

class ShakeNReportPlugin {
  static final ShakeNReportPlugin _instance = ShakeNReportPlugin._internal();

  /// Get the singleton instance of ShakeNReportPlugin
  static ShakeNReportPlugin get instance => _instance;

  ShakeNReportPlugin._internal();

  double shakeThreshold = 2.7;

  int minShakeCount = 2;

  bool isDebuggable = false;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  ManagementTools managementTool = ManagementTools.jira;

  /// Classic Jira platform REST API authorization URL
  JiraConfig? jiraConfig;

  /// Initialize the ShakeToReportPlugin
  ///
  /// This method must be called before using any other functionality of the plugin.
  ///
  /// [shakeThreshold] - The threshold for shake detection (default: 15.0)
  /// [minShakeCount] - The minimum number of shakes required to trigger an event (default: 2)
  /// [resetTime] - The time after which the shake count is reset (default: 2 seconds)
  static void initialize({
    required GlobalKey<NavigatorState> navigatorKey,
    double shakeThreshold = 15.0,
    int minShakeCount = 2,
    bool isDebuggable = false,
    ManagementTools managementTool = ManagementTools.jira,
    JiraConfig? jiraConfig,
  }) async {
    await initDI();
    _instance.minShakeCount = minShakeCount;
    _instance.shakeThreshold = shakeThreshold;
    _instance.isDebuggable = isDebuggable;
    _instance.navigatorKey = navigatorKey;
    _instance.managementTool = managementTool;
    _instance.jiraConfig = jiraConfig;
  }
}
