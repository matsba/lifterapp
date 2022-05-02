import 'package:flutter/cupertino.dart';

class WorkoutFormInput {
  String? name;
  int? reps;
  double? weigth;
  bool bodyWeigth;

  WorkoutFormInput({
    this.name = "",
    this.reps = 0,
    this.weigth = 0.0,
    this.bodyWeigth = false,
  });

  newFromFormData(Map<String, dynamic> form, WorkoutFormInput prev) {
    for (var key in form.keys) {
      if (key == "name") {
        prev.name = form[key];
      }
      if (key == "reps") {
        prev.reps = form[key];
      }
      if (key == "weigth") {
        prev.weigth = form[key];
      }
      if (key == "bodyWeigth") {
        prev.bodyWeigth = form[key];
      }
      return prev;
    }
  }

  // WorkoutFormInput.fromJson(Map<String, dynamic> json)
  //     : name = json['name'],
  //       reps = json['reps'],
  //       weigth = json['weigth'];

  // Map<String, dynamic> toJson() => {
  //       'name': name,
  //       'reps': reps,
  //       'weigth': weigth,
  //     };
}

class Workout {
  int? id;
  String name;
  int reps;
  double weigth;
  bool bodyWeigth;
  DateTime timestamp;

  int get year => timestamp.year;
  int get month => timestamp.month;
  int get day => timestamp.day;

  Workout({
    this.id,
    required this.name,
    required this.reps,
    required this.weigth,
    required this.timestamp,
    required this.bodyWeigth,
  });

  Workout.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        reps = res["reps"],
        weigth = res["weigth"],
        bodyWeigth = res["body_weigth"] > 0 ? true : false,
        timestamp = DateTime.parse(res["timestamp"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'reps': reps,
      'weigth': bodyWeigth ? 0 : weigth,
      'timestamp': timestamp.toString(),
      'body_weigth': bodyWeigth ? 1 : 0,
      'year': year,
      'month': month,
      'day': day
    };
  }
}

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

class WorkoutMinimal {
  final String name;
  final String setsRepsWeigth;
  final bool bodyWeigth;
  final List<DateTime> timestamps;

  DateTime get firstTimestamp => timestamps[0];
  DateTime get lastTimestamp => timestamps[timestamps.length - 1];

  WorkoutMinimal(
      {required this.name,
      required this.bodyWeigth,
      required this.setsRepsWeigth,
      required this.timestamps});
}

class WorkoutCard {
  final String date;
  final List<WorkoutGroup> workouts;

  String get restingTimeInMinutesAndSeconds => "0:00"; //TODO;
  String get duration {
    List<DateTime> timestamps =
        workouts.map((x) => x.timestampsInListFormat).expand((x) => x).toList();
    timestamps.sort((a, b) => a.compareTo(b));
    var difference = timestamps.last.difference(timestamps.first);
    return "${difference.inMinutes} mins";
  }

  double get overallVolume =>
      groupWorkoutsByName.map((e) => e.trainingVolume).reduce((a, b) => a + b);

  List<WorkoutNameGroup> get groupWorkoutsByName {
    List<WorkoutNameGroup> setsGrouped = [];
    List<WorkoutGroup> grouped = [];
    double volume = 0;

    void init() {
      volume = 0;
      grouped.clear();
    }

    for (var i = 0; i < workouts.length; i++) {
      var current = workouts[i];
      grouped.add(current);
      volume = grouped
          .map((workout) =>
              workout.sets *
              workout.reps *
              (workout.bodyWeigth ? 1 : workout.weigth))
          .reduce((a, b) => a + b)
          .toDouble();

      if (i + 1 >= workouts.length) {
        setsGrouped.add(WorkoutNameGroup(
            name: current.name,
            workouts: [...grouped],
            trainingVolume: volume));
        init();
        break;
      }

      var next = workouts[i + 1];

      if (current.name != next.name) {
        setsGrouped.add(WorkoutNameGroup(
            name: current.name,
            workouts: [...grouped],
            trainingVolume: volume));
        init();
      }
    }
    return setsGrouped;
  }

  WorkoutCard({required this.date, required this.workouts});
}

class WorkoutNameGroup {
  final String name;
  final List<WorkoutGroup> workouts;
  final double trainingVolume;

  WorkoutNameGroup(
      {required this.name,
      required this.workouts,
      required this.trainingVolume});
}

class OridnalWorkoutVolumes {
  final String name;
  final String group;
  final double volume;

  OridnalWorkoutVolumes(this.name, this.group, this.volume);
}

class MonthWorkoutVolumeStatistics {
  final double? acuteLoad;
  final double? chronicLoad;

  double? get ratio => acuteLoad != null && chronicLoad != null
      ? acuteLoad! / chronicLoad!
      : null;

  MonthWorkoutVolumeStatistics(
      {required this.acuteLoad, required this.chronicLoad});
}
