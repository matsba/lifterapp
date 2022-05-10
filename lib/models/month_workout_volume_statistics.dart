class MonthWorkoutVolumeStatistics {
  final double? acuteLoad;
  final double? chronicLoad;

  double? get ratio => acuteLoad != null && chronicLoad != null
      ? acuteLoad! / chronicLoad!
      : null;

  MonthWorkoutVolumeStatistics(
      {required this.acuteLoad, required this.chronicLoad});
}
