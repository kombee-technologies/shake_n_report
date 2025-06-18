import 'package:flutter/material.dart';
import 'package:shake_n_report/shake_to_report.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // // Initialize the plugin
  ShakeToReportPlugin.initialize(
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
