import '../../../../core/services/backup_service.dart';
import '../repositories/settings_repository.dart';

class RestoreBackup {
  final SettingsRepository repository;

  RestoreBackup(this.repository);

  Future<BackupMetadata> call() => repository.restoreBackup();
}
