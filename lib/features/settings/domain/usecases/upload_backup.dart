import '../../../../core/services/backup_service.dart';
import '../repositories/settings_repository.dart';

class UploadBackup {
  final SettingsRepository repository;

  UploadBackup(this.repository);

  Future<BackupMetadata> call() => repository.uploadBackup();
}
