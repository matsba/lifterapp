class WorkoutFormInput {
  String? name;
  int? reps;
  double? weigth;

  WorkoutFormInput({
    this.name = "",
    this.reps = 0,
    this.weigth = 0.0,
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
      return prev;
    }
  }

  WorkoutFormInput.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        reps = json['reps'],
        weigth = json['weigth'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'reps': reps,
        'weigth': weigth,
      };
}

class Workout {
  int? id;
  String name;
  int reps;
  double weigth;
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
  });

  Workout.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        reps = res["reps"],
        weigth = res["weigth"],
        timestamp = DateTime.parse(res["timestamp"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'reps': reps,
      'weigth': weigth,
      'timestamp': timestamp.toString(),
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
  final String? timestamps;

  String get setFormat => "$sets x $reps x $weigth kg";
  String get dateFormat => "$day.$month.$year";

  List<DateTime> get timestampsInListFormat =>
      timestamps != null && timestamps != ""
          ? timestamps!.split(",").map((x) => DateTime.parse(x)).toList()
          : List.filled(1, DateTime.now());

  WorkoutGroup({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weigth,
    required this.year,
    required this.month,
    required this.day,
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
        timestamps = res["timestamps"];
}

class WorkoutMinimal {
  final String name;
  final String setsRepsWeigth;
  final List<DateTime> timestamps;

  DateTime get firstTimestamp => timestamps[0];
  DateTime get lastTimestamp => timestamps[timestamps.length - 1];

  WorkoutMinimal(
      {required this.name,
      required this.setsRepsWeigth,
      required this.timestamps});
}

class WorkoutCard {
  final String date;
  final List<WorkoutMinimal> workouts;

  String get restingTimeInMinutesAndSeconds => "0:00"; //TODO;
  String get duration => "1:30"; //TODO implementoi

  WorkoutCard({required this.date, required this.workouts});
}
