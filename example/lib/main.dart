import 'package:flutter/material.dart';
import 'package:shake_n_report/shake_n_report.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializes the ShakeNReportPlugin with the provided configuration.
  ///
  /// [isEnabled]: A boolean indicating whether the shake-to-report feature is enabled.
  ///
  /// [shakeThreshold]: The sensitivity threshold for detecting shake gestures.
  ///                   Lower values make the shake detection more sensitive.
  ///
  /// [minShakeCount]: The minimum number of shakes required to trigger the report action.
  ///
  /// [isDebuggable]: Enables or disables debug mode for the plugin.
  ///                 When true, additional debug information may be shown in the console.
  ///
  /// [navigatorKey]: The global navigator key used for navigation within the app.
  ///
  /// [managementTool]: Specifies the management tool to integrate with (e.g., Jira).
  ///
  /// [jiraConfig]: Configuration for Jira integration.
  ///   - [clientId]: The client ID for authenticating with Jira.
  ///   - [redirectUrl]: The redirect URL used in the OAuth flow for Jira authentication.
  ///   - [clientSecret]: The client secret for authenticating with Jira.
  await ShakeNReportPlugin.initialize(
    isEnabled: true,
    shakeThreshold: 2,
    minShakeCount: 1,
    isDebuggable: true,
    navigatorKey: navigatorKey,
    managementTool: ManagementTools.jira,
    jiraConfig: JiraConfig(
      clientId: 'CLIENT_ID',
      redirectUrl: 'REDIRECT_URL', // ex, https://localhost/shake-n-report
      clientSecret: 'CLIENT_SECRET',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// A widget that wraps its child and enables "shake to report" functionality.
    ///
    /// When the device is shaken, this widget can trigger a reporting mechanism,
    /// such as opening a feedback form or sending a bug report. Place this widget
    /// above your app's root widget to enable shake detection throughout the app.
    ///
    /// Typically used to facilitate easy bug reporting or user feedback during
    /// development or in production apps.
    ///
    /// Example usage:
    ///
    /// ```dart
    /// return ShakeToReportWidget(
    ///   child: MaterialApp(
    ///     // app configuration
    ///   ),
    /// );
    /// ```
    return ShakeToReportWidget(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
