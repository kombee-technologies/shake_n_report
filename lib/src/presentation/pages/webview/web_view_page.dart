import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake_n_report/src/core/constants/my_constants.dart';
import 'package:shake_n_report/src/core/utils/utility.dart';
import 'package:shake_n_report/src/presentation/state_management/jira_management_cubit/jira_management_cubit.dart';
import 'package:shake_n_report/src/presentation/state_management/shake_detection_bloc/shake_detection_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, this.jiraLoginUrl});

  final String? jiraLoginUrl;

  @override
  State<WebViewPage> createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  Map<String, String> queryParams = <String, String>{};

  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);

  JiraManagementCubit? _jiraManagementCubit;

  late final WebViewController _controller = WebViewController()
    ..loadRequest(Uri.parse(widget.jiraLoginUrl ?? ''))
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if (request.url
              .startsWith(queryParams[MyConstants.jiraRedirectUri] ?? '')) {
            final Uri uri = Uri.parse(request.url);
            final String? accessCode =
                uri.queryParameters[MyConstants.jiraAccessCode];
            if (accessCode != null && accessCode.isNotEmpty) {
              isLoading.value = true;
              _jiraManagementCubit?.getAccessToken(accessCode);
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          Utility.debugLog('Page started loading: $url');
          isLoading.value = true;
        },
        onPageFinished: (String url) {
          isLoading.value = false;
        },
        onWebResourceError: (WebResourceError error) {
          isLoading.value = false;
        },
      ),
    );

  @override
  void initState() {
    _jiraManagementCubit = context.read<JiraManagementCubit>();
    if (widget.jiraLoginUrl != null) {
      final Uri uri = Uri.parse(widget.jiraLoginUrl!);
      queryParams = uri.queryParameters;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            MyConstants.jiraLogin,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 24,
              ),
              onPressed: () {
                context.read<ShakeDetectionCubit>().resetState();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            WebViewWidget(
              controller: _controller,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (BuildContext context, bool isLoading, Widget? child) =>
                  isLoading
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      );
}
