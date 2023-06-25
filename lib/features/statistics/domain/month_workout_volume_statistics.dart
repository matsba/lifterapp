class MonthWorkoutVolume {
  final double? acuteLoad;
  final double? chronicLoad;

  double? get ratio => acuteLoad != null && chronicLoad != null
      ? acuteLoad! / chronicLoad!
      : null;

  String get formattedAcuteLoad =>
      acuteLoad != null ? acuteLoad!.toStringAsFixed(0) : "0";
  String get formattedChronicLoad =>
      chronicLoad != null ? chronicLoad!.toStringAsFixed(0) : "0";
  String get formattedRatio => ratio != null ? ratio!.toStringAsFixed(2) : "0";

  MonthWorkoutVolume({required this.acuteLoad, required this.chronicLoad});
}
