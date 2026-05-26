class ActivityLogEntity {
  final int? id;
  final String action;
  final String targetType;
  final int targetId;
  final String targetName;
  final String description;
  final DateTime createdAt;

  const ActivityLogEntity({
    this.id,
    required this.action,
    required this.targetType,
    required this.targetId,
    required this.targetName,
    required this.description,
    required this.createdAt,
  });
}
