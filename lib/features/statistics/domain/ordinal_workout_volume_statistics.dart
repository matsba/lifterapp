class OrdinalWorkoutVolumeStatistics {
  final List<OridnalWorkoutVolume> ordinalWorkoutVolumes;
  final List<String> exerciseNames;

  String get selectedFilter => ordinalWorkoutVolumes.isNotEmpty
      ? ordinalWorkoutVolumes.first.name
      : "Kaikki";

  OrdinalWorkoutVolumeStatistics(
      {required this.ordinalWorkoutVolumes, required this.exerciseNames});
}

class OridnalWorkoutVolume {
  final String name;
  final String group;
  final double volume;

  static _formatGroupName(var res) {
    return "${res["weeknum"]}/${res["year"].toString().substring(2, 4)}";
  }

  OridnalWorkoutVolume(
      {required this.name, required this.group, required this.volume});

  OridnalWorkoutVolume.fromMap(Map<String, dynamic> res, this.name)
      : group = _formatGroupName(res),
        volume = double.parse(res["volume"].toString());
}
