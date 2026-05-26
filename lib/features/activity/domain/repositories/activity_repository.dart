import '../entities/activity_log_entity.dart';

abstract class ActivityRepository {
  Future<List<ActivityLogEntity>> getActivities({
    required int limit,
    required int offset,
  });
}
