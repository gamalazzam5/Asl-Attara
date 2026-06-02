import '../../../../core/services/backup_service.dart';

abstract class SettingsRepository {
  Future<BackupMetadata?> getBackupMetadata();

  Future<BackupMetadata> uploadBackup();

  Future<BackupMetadata> restoreBackup();
}
