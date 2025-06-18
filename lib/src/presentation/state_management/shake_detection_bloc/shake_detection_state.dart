import 'package:equatable/equatable.dart';

abstract class ShakeDetectionState extends Equatable {
  const ShakeDetectionState();

  @override
  List<Object> get props => <Object>[];
}

class ShakeDetectionInitial extends ShakeDetectionState {}

class ShakeDetectedState extends ShakeDetectionState {
  final DateTime timestamp;

  const ShakeDetectedState(this.timestamp);

  @override
  List<Object> get props => <Object>[timestamp];
}
