class WorkoutGroup {
  final String name;
  final int sets;
  final int reps;
  final double weigth;
  final int year;
  final int month;
  final int day;
  final bool bodyWeigth;
  final String? timestamps;

  String get setFormat =>
      bodyWeigth ? "$sets x $reps" : "$sets x $reps x $weigth kg";
  String get dateFormat => "$day.$month.$year";
  double get trainingVolume => sets * reps * (bodyWeigth ? 0 : weigth);

  List<DateTime> get timestampsInListFormat =>
      timestamps != null && timestamps != ""
          ? timestamps!.split(",").map((x) => DateTime.parse(x)).toList()
          : List.filled(1, DateTime.now());

  DateTime get firstTimestamp => timestampsInListFormat[0];
  DateTime get lastTimestamp =>
      timestampsInListFormat[timestampsInListFormat.length - 1];

  WorkoutGroup({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weigth,
    required this.year,
    required this.month,
    required this.day,
    required this.bodyWeigth,
    this.timestamps,
  });

  WorkoutGroup.fromMap(Map<String, dynamic> res)
      : name = res["name"],
        sets = res["sets"],
        reps = res["reps"],
        weigth = res["weigth"],
        year = res["year"],
        month = res["month"],
        day = res["day"],
        bodyWeigth = res["body_weigth"] > 0 ? true : false,
        timestamps = res["timestamps"];
}
