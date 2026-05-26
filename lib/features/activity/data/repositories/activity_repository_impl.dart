import '../../domain/entities/activity_log_entity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasource/activity_local_data_source.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDataSource localDataSource;

  ActivityRepositoryImpl(this.localDataSource);

  @override
  Future<List<ActivityLogEntity>> getActivities({
    required int limit,
    required int offset,
  }) {
    return localDataSource.getActivities(limit: limit, offset: offset);
  }
}
