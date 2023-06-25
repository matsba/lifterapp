import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/services/notification_service.dart';

final restingTimeProvider =
    StateProvider<Duration>((ref) => Duration(seconds: 0));

final cancelRestingTimeProvider = FutureProvider.autoDispose<void>((ref) async {
  await NotificationService().cancelScheduledNotification();
  ref.refresh(restingTimeProvider);
});
