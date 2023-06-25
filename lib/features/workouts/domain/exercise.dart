class Exercise {
  int? _id;
  String name;
  Duration restingTimeBetweenSets;
  bool isBodyWeigth;

  bool get isPersisted => _id != null;
  int? get id => _id;

  Exercise(
      {required this.name,
      this.restingTimeBetweenSets = const Duration(seconds: 90),
      this.isBodyWeigth = false});

  //Serialization
  Exercise.fromMap(Map<String, dynamic> res)
      : _id = res["id"],
        name = res["name"],
        isBodyWeigth = res["is_body_weigth"] == 1 ? true : false,
        restingTimeBetweenSets = res["resting_time_between_sets"] != null
            ? Duration(seconds: res["resting_time_between_sets"])
            : Duration(seconds: 90);

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': name,
      'resting_time_between_sets': restingTimeBetweenSets.inSeconds,
      'is_body_weigth': isBodyWeigth ? 1 : 0
    };
  }

  @override
  toString() =>
      "id: $_id, name: $name, restingTimeBetweenSets: $restingTimeBetweenSets, isBodyWeigth: $isBodyWeigth";
}
