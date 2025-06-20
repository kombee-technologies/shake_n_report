import 'package:flutter/material.dart';
import 'package:shake_n_report/src/core/constants/enums.dart';
import 'package:shake_n_report/src/core/di.dart';
import 'package:shake_n_report/src/data/models/jira/jira_config.dart';

class ShakeNReportPlugin {
  static final ShakeNReportPlugin _instance = ShakeNReportPlugin._internal();

  /// Get the singleton instance of ShakeNReportPlugin
  static ShakeNReportPlugin get instance => _instance;

  ShakeNReportPlugin._internal();

  /// The minimum acceleration required to register a shake event.
  /// A higher value makes shake detection less sensitive.
  double shakeThreshold = 2.7;

  /// The minimum number of shakes required to trigger the shake event.
  int minShakeCount = 2;

  /// Indicates whether the plugin is running in debug mode and logs are shown in the console.
  bool isDebuggable = false;

  /// The global navigator key used for navigation within the app.
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// The management tool used for issue tracking and reporting.
  ManagementTools managementTool = ManagementTools.jira;

  /// Configuration for connecting to a classic Jira platform using REST API authorization.
  /// Classic Jira platform REST API authorization URL
  JiraConfig? jiraConfig;

  /// Indicates whether the shake-to-report feature is enabled.
  /// If set to false, the shake detection will not trigger any actions.
  /// This can be useful for temporarily disabling the feature without removing the code.
  /// Default is true.
  /// Set to false to disable shake detection and reporting.
  /// This can be useful when you are using flavour or feature flags to control the availability of the shake-to-report feature.
  /// For example, you might want to disable it in production builds or when the feature is not needed.
  bool isEnabled = true;

  /// Initialize the ShakeToReportPlugin
  ///
  /// This method must be called before using any other functionality of the plugin.
  ///
  /// [shakeThreshold] - The threshold for shake detection (default: 15.0)
  /// [minShakeCount] - The minimum number of shakes required to trigger an event (default: 2)
  /// [isDebuggable] - Whether the plugin is running in debug mode (default: false)
  /// [navigatorKey] - The global navigator key used for navigation within the app
  /// [managementTool] - The management tool to integrate with (default: ManagementTools.jira)
  /// [jiraConfig] - Configuration for Jira integration, **required** if managementTool is ManagementTools.jira.
  /// [jiraConfig] is required when [managementTool] is ManagementTools.jira
  static Future<void> initialize({
    required GlobalKey<NavigatorState> navigatorKey,
    required bool isEnabled,
    double shakeThreshold = 15.0,
    int minShakeCount = 2,
    bool isDebuggable = false,
    ManagementTools managementTool = ManagementTools.jira,
    JiraConfig? jiraConfig,
  }) async {
    // Runtime validation
    assert(
      managementTool != ManagementTools.jira,
      'JiraConfig must be provided when managementTool is set to ManagementTools.jira',
    );

    await initDI();
    _instance.isEnabled = isEnabled;
    _instance.minShakeCount = minShakeCount;
    _instance.shakeThreshold = shakeThreshold;
    _instance.isDebuggable = isDebuggable;
    _instance.navigatorKey = navigatorKey;
    _instance.managementTool = managementTool;
    _instance.jiraConfig = jiraConfig;
  }
}
