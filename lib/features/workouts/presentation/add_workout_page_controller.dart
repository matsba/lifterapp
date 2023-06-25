import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/features/settings/presentation/settings_page_controller.dart';
import 'package:lifterapp/features/workouts/data/workouts_repository.dart';
import 'package:lifterapp/features/workouts/domain/exercise.dart';
import 'package:lifterapp/features/workouts/domain/session.dart';
import 'package:lifterapp/features/workouts/domain/workout.dart';
import 'package:lifterapp/features/workouts/domain/add_workout_form.dart';
import 'package:lifterapp/features/workouts/domain/workout_set.dart';
import 'package:lifterapp/features/workouts/presentation/list_page_controller.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/resting_time_counter_controller.dart';
import 'package:lifterapp/services/notification_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddWorkoutFormStateNotifier extends StateNotifier<AddWorkoutForm> {
  AddWorkoutFormStateNotifier() : super(AddWorkoutForm.init());

  void setName(String name) {
    state = state.copyWith(exerciseName: name);
  }

  void setReps(int reps) {
    state = state.copyWith(workoutReps: reps);
  }

  void setWeigth(double weigth) {
    state = state.copyWith(workoutWeigth: weigth);
  }

  void setIsBodyWeigth(bool isBodyWeigth) {
    state = state.copyWith(exerciseIsBodyWeigth: isBodyWeigth);
  }
}

enum WorkoutSubmitState { pending, saved, error, editing }

class WorkoutSubmitStateNotifier extends StateNotifier<WorkoutSubmitState> {
  final StateNotifierProviderRef<WorkoutSubmitStateNotifier, WorkoutSubmitState>
      ref;

  WorkoutSubmitStateNotifier(this.ref) : super(WorkoutSubmitState.editing);

  Future<void> submit(AddWorkoutForm form) async {
    state = WorkoutSubmitState.pending;

    if (!form.validate()) {
      state = WorkoutSubmitState.error;
      return;
    }

    final workoutsRepository = ref.watch(workoutsRepositoryProvider);

    Session? latestSession = await workoutsRepository.getLatestSession();
    Session newSession = Session(workouts: [], timestamp: DateTime.now());

    if (latestSession == null || !latestSession.isStartedInPastHours(4)) {
      latestSession = await workoutsRepository.saveSession(newSession, 1);
    }

    Exercise? exercise =
        await workoutsRepository.getExerciseByName(form.exerciseName);
    Exercise newExercise = Exercise(
        name: form.exerciseName, isBodyWeigth: form.exerciseIsBodyWeigth);

    exercise ??= await workoutsRepository.saveExercise(newExercise);

    Workout? workout = latestSession.workoutFromSession(exercise);
    Workout newWorkout = Workout(exercise: exercise, sets: []);

    workout ??=
        await workoutsRepository.saveWorkout(newWorkout, latestSession.id!);

    WorkoutSet workoutSet = WorkoutSet(
        reps: form.workoutReps,
        weigth: form.workoutWeigth,
        timestamp: DateTime.now());

    await workoutsRepository.saveSet(workoutSet, workout.id!);

    ref.read(restingTimeProvider.notifier).state =
        exercise.restingTimeBetweenSets;

    state = WorkoutSubmitState.saved;

    ref.watch(usingRestingTimeFeatureProvider).whenData((usingFeature) {
      if (usingFeature) {
        ref.read(notificationProvider).scheduleNotification(
            seconds: exercise!.restingTimeBetweenSets.inSeconds);
      }
    });

    ref.invalidate(workoutsRepositoryProvider);

    state = WorkoutSubmitState.editing;
  }
}

final addWorkoutFormProvider =
    StateNotifierProvider<AddWorkoutFormStateNotifier, AddWorkoutForm>(
        (ref) => AddWorkoutFormStateNotifier());

final workoutSubmitStateProvider =
    StateNotifierProvider<WorkoutSubmitStateNotifier, WorkoutSubmitState>(
        (ref) => WorkoutSubmitStateNotifier(ref));

final exerciseProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final workoutsRepository = ref.watch(workoutsRepositoryProvider);
  final exercises = await workoutsRepository.getAllExercises();
  return exercises.map((e) => e.name).toList();
});

final latestWorkoutProvider = FutureProvider.autoDispose
    .family<Workout?, String>((ref, workoutName) async {
  final workoutsRepository = ref.watch(workoutsRepositoryProvider);
  final training = await workoutsRepository.getTraining(1);
  if (training == null) {
    return null;
  }
  return training.latestWorkoutByName(workoutName);
});
