import '../entities/activity_log_entity.dart';
import '../repositories/activity_repository.dart';

class GetActivities {
  final ActivityRepository repository;

  GetActivities(this.repository);

  Future<List<ActivityLogEntity>> call({
    required int limit,
    required int offset,
  }) {
    return repository.getActivities(limit: limit, offset: offset);
  }
}
