import 'package:flutter/material.dart';
import 'package:shake_n_report/src/core/constants/enums.dart';
import 'package:shake_n_report/src/core/di.dart';
import 'package:shake_n_report/src/data/models/jira/jira_config.dart';

class ShakeNReportPlugin {
  static final ShakeNReportPlugin _instance = ShakeNReportPlugin._internal();

  /// Get the singleton instance of ShakeNReportPlugin
  static ShakeNReportPlugin get instance => _instance;

  ShakeNReportPlugin._internal();

  static void registerWith() {
    // Plugin registration - intentionally empty
    // The actual initialization happens via the initialize() method
  }

  /// The minimum acceleration (in g-force units) required to register a shake event.
  /// 
  /// This threshold determines the sensitivity of shake detection:
  /// - **Lower values (1.0-3.0)**: More sensitive - detects gentle shakes
  /// - **Medium values (3.0-5.0)**: Balanced - detects normal shakes
  /// - **Higher values (5.0+)**: Less sensitive - requires vigorous shaking
  /// 
  /// **Recommended values:**
  /// - For development/testing: 2.0-3.0
  /// - For production: 3.0-4.0
  /// 
  /// The default value is optimized for most use cases.
  /// Note: Values below 1.0 may cause false positives, values above 10.0 may be too insensitive.
  double shakeThreshold = 2.7;

  /// The minimum number of consecutive shake events required to trigger the report interface.
  /// 
  /// This helps prevent accidental triggers:
  /// - **1**: Triggers on first shake (most sensitive, may have false positives)
  /// - **2-3**: Recommended for most use cases (balanced sensitivity)
  /// - **4+**: Requires multiple shakes (reduces false positives but may be less responsive)
  /// 
  /// **Recommended:** 2 shakes for production, 1 for development/testing.
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
  /// **Required Parameters:**
  /// - [navigatorKey] - The global navigator key used for navigation within the app
  /// - [isEnabled] - Whether shake detection is enabled
  ///
  /// **Optional Parameters:**
  /// - [shakeThreshold] - The acceleration threshold for shake detection in g-force units.
  ///   Recommended range: 2.0-4.0. Lower = more sensitive, Higher = less sensitive.
  ///   Default: 2.7 (optimized for most use cases)
  /// - [minShakeCount] - Minimum consecutive shakes required to trigger (1-5 recommended).
  ///   Default: 2 (balanced sensitivity)
  /// - [isDebuggable] - Enable debug logging (default: false)
  /// - [managementTool] - The management tool to integrate with (default: ManagementTools.jira)
  /// - [jiraConfig] - **Required** when managementTool is ManagementTools.jira
  ///
  /// **Example:**
  /// ```dart
  /// await ShakeNReportPlugin.initialize(
  ///   navigatorKey: navigatorKey,
  ///   isEnabled: true,
  ///   shakeThreshold: 2.7,  // Medium sensitivity
  ///   minShakeCount: 2,      // Requires 2 shakes
  ///   jiraConfig: JiraConfig(...),
  /// );
  /// ```
  static Future<void> initialize({
    required GlobalKey<NavigatorState> navigatorKey,
    required bool isEnabled,
    double shakeThreshold = 2.7,
    int minShakeCount = 2,
    bool isDebuggable = false,
    ManagementTools managementTool = ManagementTools.jira,
    JiraConfig? jiraConfig,
  }) async {
    // Validate shakeThreshold range
    assert(
      shakeThreshold >= 1.0 && shakeThreshold <= 20.0,
      'shakeThreshold must be between 1.0 and 20.0. Recommended: 2.0-4.0',
    );

    // Validate minShakeCount range
    assert(
      minShakeCount >= 1 && minShakeCount <= 10,
      'minShakeCount must be between 1 and 10. Recommended: 1-3',
    );

    // Runtime validation for Jira config
    assert(
      managementTool != ManagementTools.jira || jiraConfig != null,
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
