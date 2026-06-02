import '../../../../core/services/backup_service.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final BackupService backupService;

  SettingsRepositoryImpl(this.backupService);

  @override
  Future<BackupMetadata?> getBackupMetadata() {
    return backupService.getBackupMetadata();
  }

  @override
  Future<BackupMetadata> restoreBackup() {
    return backupService.restoreBackup();
  }

  @override
  Future<BackupMetadata> uploadBackup() {
    return backupService.uploadBackup();
  }
}
