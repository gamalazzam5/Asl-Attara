import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/activity_log_table.dart';
import '../models/activity_log_model.dart';

class ActivityLocalDataSource {
  final AppDatabase appDatabase;

  ActivityLocalDataSource(this.appDatabase);

  Future<List<ActivityLogModel>> getActivities({
    required int limit,
    required int offset,
  }) async {
    final db = await appDatabase.database;
    final result = await db.query(
      ActivityLogTable.tableName,
      orderBy: '${ActivityLogTable.createdAt} DESC',
      limit: limit,
      offset: offset,
    );

    return result.map(ActivityLogModel.fromJson).toList();
  }

  Future<void> addActivity(ActivityLogModel activity) async {
    final db = await appDatabase.database;
    await db.insert(ActivityLogTable.tableName, activity.toJson());
  }
}
