import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake_n_report/src/core/constants/enums.dart';
import 'package:shake_n_report/src/core/constants/my_constants.dart';
import 'package:shake_n_report/src/core/shake_n_report_plugin.dart';
import 'package:shake_n_report/src/core/utils/utility.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage_keys.dart';
import 'package:shake_n_report/src/presentation/pages/jira_project_selection/project_selection.dart';
import 'package:shake_n_report/src/presentation/pages/webview/web_view_page.dart';
import 'package:shake_n_report/src/presentation/state_management/shake_detection_bloc/shake_detection_state.dart';

class ShakeDetectionCubit extends Cubit<ShakeDetectionState> {
  ShakeDetectionCubit() : super(const ShakeDetectionInitial());

  Future<void> onShakeDetected(DateTime timestamp) async {
    switch (ShakeNReportPlugin.instance.managementTool) {
      case ManagementTools.jira:
        if (ShakeNReportPlugin.instance.jiraConfig?.isValid() ?? false) {
          Utility.infoLog('Jira tool selected');
          emit(ShakeDetectedState(timestamp));
          final String accessToken = await LocalStorage.instance.getStringData(LocalStorageKeys.jiraAccessToken);
          final String refreshToken = await LocalStorage.instance.getStringData(LocalStorageKeys.jiraRefreshToken);
          final BuildContext? context = ShakeNReportPlugin.instance.navigatorKey.currentContext;
          if (accessToken.isNotEmpty || refreshToken.isNotEmpty) {
            if (context != null && context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ProjectSelectionScreen(),
                ),
              );
            }
          } else {
            final String clientId = ShakeNReportPlugin.instance.jiraConfig?.clientId ?? '';
            final String redirectUrl = ShakeNReportPlugin.instance.jiraConfig?.redirectUrl ?? '';
            final String jiraLoginUrl =
                'https://auth.atlassian.com/authorize?audience=api.atlassian.com&client_id=$clientId&scope=${MyConstants.jiraScopes}&redirect_uri=$redirectUrl&state=${MyConstants.state}&response_type=code&prompt=consent';

            if (context != null && context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => WebViewPage(
                    jiraLoginUrl: jiraLoginUrl,
                  ),
                ),
              );
            } else {
              Utility.showSnackbar(
                  msg: 'Jira tool selected but missing query parameters in URL. (client_id, scope, redirect_uri)');
            }
          }
        } else {
          Utility.showSnackbar(msg: 'Jira tool selected but no config provided.');
        }
        break;
      // default:
      //   Utility.debugLog('No tools selected');
      //   break;
    }
  }

  void resetState() {
    emit(const ShakeDetectionInitial());
  }
}
