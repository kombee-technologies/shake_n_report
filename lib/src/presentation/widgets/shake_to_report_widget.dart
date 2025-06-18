import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:shake/shake.dart';
import 'package:shake_n_report/shake_to_report.dart';
import 'package:shake_n_report/src/core/utils/utility.dart';
import 'package:shake_n_report/src/presentation/state_management/jira_management_cubit/jira_management_cubit.dart';
import 'package:shake_n_report/src/presentation/state_management/shake_detection_bloc/shake_detection_cubit.dart';
import 'package:shake_n_report/src/presentation/state_management/shake_detection_bloc/shake_detection_state.dart';
import 'package:toastification/toastification.dart';

class ShakeToReportWidget extends StatefulWidget {
  final Widget child;

  const ShakeToReportWidget({
    required this.child,
    super.key,
  });

  @override
  State<ShakeToReportWidget> createState() => _ShakeToReportWidgetState();
}

class _ShakeToReportWidgetState extends State<ShakeToReportWidget> {
  late final ShakeDetectionCubit _shakeDetectionCubit;
  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();
    _shakeDetectionCubit = ShakeDetectionCubit();

    _shakeDetector = ShakeDetector.waitForStart(
      onPhoneShake: (ShakeEvent e) {
        Utility.infoLog('onPhoneShake: Got it! ${e.direction} || ${e.force}');
        if (_shakeDetectionCubit.state is ShakeDetectionInitial) {
          _shakeDetectionCubit.onShakeDetected(e.timestamp);
        }
      },
      shakeThresholdGravity: ShakeToReportPlugin.instance.shakeThreshold,
      minimumShakeCount: ShakeToReportPlugin.instance.minShakeCount,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _shakeDetector?.startListening();
    });
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    _shakeDetectionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<ShakeDetectionCubit>.value(
            value: _shakeDetectionCubit,
          ),
          BlocProvider<JiraManagementCubit>(create: (_) => JiraManagementCubit()),
        ],
        child: ToastificationWrapper(
          child: widget.child,
        ),
      );
}
