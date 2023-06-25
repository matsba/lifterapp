// ignore_for_file: unused_import

import 'package:lifterapp/app.dart';
import 'package:lifterapp/common_widgets/app_scaffold.dart';
import 'package:lifterapp/common_widgets/info_snackbar.dart';
import 'package:lifterapp/common_widgets/info_text.dart';
import 'package:lifterapp/common_widgets/more_menu.dart';
import 'package:lifterapp/common_widgets/title_row.dart';
import 'package:lifterapp/contants.dart';
import 'package:lifterapp/features/settings/data/settings_repository.dart';
import 'package:lifterapp/features/settings/presentation/settings_page.dart';
import 'package:lifterapp/features/settings/presentation/settings_page_controller.dart';
import 'package:lifterapp/features/statistics/data/statistics_repository.dart';
import 'package:lifterapp/features/statistics/domain/month_workout_volume_statistics.dart';
import 'package:lifterapp/features/statistics/domain/ordinal_workout_volume_statistics.dart';
import 'package:lifterapp/features/statistics/presentation/stats_page.dart';
import 'package:lifterapp/features/statistics/presentation/stats_page_controller.dart';
import 'package:lifterapp/features/workouts/data/workouts_repository.dart';
import 'package:lifterapp/features/workouts/domain/add_workout_form.dart';
import 'package:lifterapp/features/workouts/domain/exercise.dart';
import 'package:lifterapp/features/workouts/domain/session.dart';
import 'package:lifterapp/features/workouts/domain/training.dart';
import 'package:lifterapp/features/workouts/domain/workout.dart';
import 'package:lifterapp/features/workouts/domain/workout_set.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page_controller.dart';
import 'package:lifterapp/features/workouts/presentation/list_page.dart';
import 'package:lifterapp/features/workouts/presentation/list_page_controller.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/input_submit_button.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/input_workout_name.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/input_workout_reps.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/input_workout_weigth.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/latest_workout_card.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/resting_time_counter.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/resting_time_counter_controller.dart';
import 'package:lifterapp/main.dart';
import 'package:lifterapp/routing/bottom_navigationbar.dart';
import 'package:lifterapp/routing/home_page.dart';
import 'package:lifterapp/routing/navigation_service.dart';
import 'package:lifterapp/routing/selected_page_provider.dart';
import 'package:lifterapp/services/database_provider.dart';
import 'package:lifterapp/services/database_service.dart';
import 'package:lifterapp/services/notification_provider.dart';
import 'package:lifterapp/services/notification_service.dart';
import 'package:lifterapp/theme.dart';
import 'package:lifterapp/utils/formatter.dart';

void main() {}

