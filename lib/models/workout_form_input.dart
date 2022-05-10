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
