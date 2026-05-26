import '../../../domain/entities/activity_log_entity.dart';

abstract class ActivityState {}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final List<ActivityLogEntity> activities;
  final bool hasMore;
  final bool isLoadingMore;

  ActivityLoaded({
    required this.activities,
    required this.hasMore,
    this.isLoadingMore = false,
  });
}

class ActivityError extends ActivityState {
  final String message;

  ActivityError(this.message);
}
