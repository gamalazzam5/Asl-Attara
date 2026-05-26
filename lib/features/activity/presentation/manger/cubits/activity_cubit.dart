import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/activity_log_entity.dart';
import '../../../domain/usecases/get_activities.dart';
import 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  static const pageSize = 20;

  final GetActivities getActivitiesUseCase;

  ActivityCubit(this.getActivitiesUseCase) : super(ActivityInitial());

  final List<ActivityLogEntity> _activities = [];
  bool _hasMore = true;
  bool _isLoading = false;

  Future<void> loadActivities({bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;

    if (refresh) {
      _activities.clear();
      _hasMore = true;
    }

    if (_activities.isEmpty) {
      emit(ActivityLoading());
    } else {
      emit(
        ActivityLoaded(
          activities: List.from(_activities),
          hasMore: _hasMore,
          isLoadingMore: true,
        ),
      );
    }

    try {
      final page = await getActivitiesUseCase(
        limit: pageSize,
        offset: _activities.length,
      );

      _activities.addAll(page);
      _hasMore = page.length == pageSize;

      emit(
        ActivityLoaded(activities: List.from(_activities), hasMore: _hasMore),
      );
    } catch (e) {
      emit(ActivityError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }
}
