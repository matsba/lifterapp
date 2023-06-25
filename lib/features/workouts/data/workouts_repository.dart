import 'package:lifterapp/features/workouts/domain/exercise.dart';
import 'package:lifterapp/features/workouts/domain/session.dart';
import 'package:lifterapp/features/workouts/domain/training.dart';
import 'package:lifterapp/features/workouts/domain/workout_set.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page_controller.dart';
import 'package:lifterapp/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lifterapp/features/workouts/domain/workout.dart';
import 'dart:async';

class WorkoutsRepository {
  final Database db;

  WorkoutsRepository({required this.db});

  Future<Training?> getTraining(int id) async {
    var result = await db.query('training', where: "id = $id");

    if (result.isNotEmpty) {
      var training = result.first;
      return Training.fromMap(training, await _getSessionsForTraining(id));
    }

    return null;
  }

  String _toSqlList(List arr) => "(${arr.join(",")})";

  Future<List<WorkoutSet>> _getSetsForWorkouts(List<int> workoutIds) async {
    var result = await db.query('sets',
        where: "fk_workout_id IN ${_toSqlList(workoutIds)}");

    if (result.isNotEmpty) {
      var sets = result.map((e) => WorkoutSet.fromMap(e)).toList();
      return sets;
    }

    return [];
  }

  Future<Exercise> getExercise(int id) async {
    var result = await db.query('exercise', where: "id = $id");

    if (result.isNotEmpty) {
      var exercise = result.first;
      return Exercise(name: exercise["name"].toString());
    }

    return Exercise(name: "");
  }

  Future<Exercise?> getExerciseByName(String name) async {
    var result = await db.query('exercise', where: 'name = "$name"');

    if (result.isNotEmpty) {
      var exercise = result.first;
      return Exercise.fromMap(exercise);
    }
  }

  Future<List<Workout>> _getWorkoutsForSession(List<int> sessionIds) async {
    var result = await db.rawQuery("""
        SELECT workout.id,
              workout.fk_session_id,
              workout.fk_exercise_id,
              exercise.id AS exercise_id,
              exercise.resting_time_between_sets,
              exercise.is_body_weigth,
              exercise.name
          FROM workout
              JOIN
              exercise ON workout.fk_exercise_id = exercise.id
        WHERE workout.fk_session_id IN ${_toSqlList(sessionIds)};""");

    if (result.isNotEmpty) {
      var sets =
          await _getSetsForWorkouts(result.map((e) => e["id"] as int).toList());

      var workouts = result
          .map((e) => Workout.fromMap(
              e,
              sets
                  .where((element) => element.workoutId == e["id"] as int)
                  .toList(),
              Exercise.fromMap(e)))
          .toList();
      return workouts;
    }

    return [];
  }

  Future<List<Session>> _getSessionsForTraining(int trainingId) async {
    var result = await db.rawQuery("""
        SELECT *,
            row_number() OVER (ORDER BY timestamp ASC) AS number
        FROM session
        WHERE fk_training_id = $trainingId
        ORDER BY timestamp DESC""");

    if (result.isNotEmpty) {
      var workouts = await _getWorkoutsForSession(
          result.map((e) => e["id"] as int).toList());

      var sessions = result
          .map((e) => Session.fromMap(
              e,
              workouts
                  .where((element) => element.sessionId == e["id"] as int)
                  .toList()))
          .toList();

      return sessions;
    }

    return [];
  }

  Future<List<Exercise>> getAllExercises() async {
    var result = await db.query("exercise");

    if (result.isNotEmpty) {
      return result.map((e) => Exercise.fromMap(e)).toList();
    }

    return [];
  }

  Future<Session> _getSessionById(int id) async {
    var res = await db.query("session", where: "id = $id");
    if (res.first.isEmpty) {
      throw Exception("No session found with given id");
    }

    var workouts = await _getWorkoutsForSession([id]);
    return Session.fromMap(res.first, workouts);
  }

  Future<Exercise> _getExerciseById(int id) async {
    var res = await db.query("exercise", where: "id = $id");
    if (res.first.isEmpty) {
      throw Exception("No exercise found with given id");
    }

    return Exercise.fromMap(res.first);
  }

  Future<Workout> _getWorkoutById(int id) async {
    var res = await db.query("workout", where: "id = $id");
    if (res.first.isEmpty) {
      throw Exception("No workout found with given id");
    }

    var exercise = await _getExerciseById(res.first["fk_exercise_id"] as int);
    var sets = await _getSetsForWorkouts([res.first["id"] as int]);

    return Workout.fromMap(res.first, sets, exercise);
  }

  Future<WorkoutSet> _getWorkoutSetById(int id) async {
    var res = await db.query("sets", where: "id = $id");
    if (res.first.isEmpty) {
      throw Exception("No workout set found with given id");
    }
    return WorkoutSet.fromMap(res.first);
  }

  Future<Session> saveSession(Session session, int trainingId) async {
    var id = await db.insert("session", session.toMap(trainingId: trainingId));
    return _getSessionById(id);
  }

  Future<Workout> saveWorkout(Workout workout, int sessionId) async {
    var id = await db.insert("workout", workout.toMap(sessionId: sessionId));
    return await _getWorkoutById(id);
  }

  Future<WorkoutSet> saveSet(WorkoutSet workoutSet, int workoutId) async {
    var id = await db.insert("sets", workoutSet.toMap(workoutId: workoutId));
    return await _getWorkoutSetById(id);
  }

  Future<Exercise> saveExercise(Exercise exercise) async {
    var id = await db.insert("exercise", exercise.toMap());
    return await _getExerciseById(id);
  }

  Future<Session?> getLatestSession() async {
    var result = await db.rawQuery("""
      SELECT *
        FROM session
      WHERE fk_training_id = 1
      ORDER BY timestamp DESC
      LIMIT 1;
    """);

    if (result.isNotEmpty) {
      return Session.fromMap(result.first,
          await _getWorkoutsForSession([result.first["id"] as int]));
    }

    return null;
  }

  Future<void> deleteSet(int id) async {
    await db.delete("sets", where: "id = $id");
  }
}
