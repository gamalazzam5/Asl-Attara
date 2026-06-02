import '../../../../core/services/backup_service.dart';
import '../repositories/settings_repository.dart';

class GetBackupMetadata {
  final SettingsRepository repository;

  GetBackupMetadata(this.repository);

  Future<BackupMetadata?> call() => repository.getBackupMetadata();
}
