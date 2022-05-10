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
