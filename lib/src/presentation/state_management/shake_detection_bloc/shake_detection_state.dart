abstract class ShakeDetectionState {
  const ShakeDetectionState();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShakeDetectionState && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

class ShakeDetectionInitial extends ShakeDetectionState {
  const ShakeDetectionInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShakeDetectionInitial && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

class ShakeDetectedState extends ShakeDetectionState {
  final DateTime timestamp;

  const ShakeDetectedState(this.timestamp);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShakeDetectedState &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp;

  @override
  int get hashCode => timestamp.hashCode;
}

