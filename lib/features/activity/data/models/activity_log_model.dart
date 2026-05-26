import '../../../../core/database/tables/activity_log_table.dart';
import '../../domain/entities/activity_log_entity.dart';

class ActivityLogModel extends ActivityLogEntity {
  const ActivityLogModel({
    super.id,
    required super.action,
    required super.targetType,
    required super.targetId,
    required super.targetName,
    required super.description,
    required super.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json[ActivityLogTable.id] as int?,
      action: json[ActivityLogTable.action] as String,
      targetType: json[ActivityLogTable.targetType] as String,
      targetId: json[ActivityLogTable.targetId] as int,
      targetName: json[ActivityLogTable.targetName] as String,
      description: json[ActivityLogTable.description] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json[ActivityLogTable.createdAt] as int,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ActivityLogTable.action: action,
      ActivityLogTable.targetType: targetType,
      ActivityLogTable.targetId: targetId,
      ActivityLogTable.targetName: targetName,
      ActivityLogTable.description: description,
      ActivityLogTable.createdAt: createdAt.millisecondsSinceEpoch,
    };
  }
}
