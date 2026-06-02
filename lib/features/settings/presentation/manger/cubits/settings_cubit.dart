import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_backup_metadata.dart';
import '../../../domain/usecases/restore_backup.dart';
import '../../../domain/usecases/upload_backup.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetBackupMetadata getBackupMetadataUseCase;
  final UploadBackup uploadBackupUseCase;
  final RestoreBackup restoreBackupUseCase;
  final Future<void> Function()? onBackupRestored;

  SettingsCubit(
    this.getBackupMetadataUseCase,
    this.uploadBackupUseCase,
    this.restoreBackupUseCase, {
    this.onBackupRestored,
  }) : super(const SettingsState.initial());

  Future<void> loadBackupMetadata() async {
    emit(state.copyWith(isLoading: true, clearMessages: true));

    try {
      final metadata = await getBackupMetadataUseCase();
      emit(state.copyWith(metadata: metadata, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'تعذر تحميل بيانات النسخة الاحتياطية',
        ),
      );
    }
  }

  Future<void> uploadBackup() async {
    emit(
      state.copyWith(
        isLoading: true,
        action: SettingsAction.upload,
        clearMessages: true,
      ),
    );

    try {
      final metadata = await uploadBackupUseCase();
      emit(
        state.copyWith(
          metadata: metadata,
          isLoading: false,
          action: SettingsAction.none,
          successMessage: 'تم رفع النسخة الاحتياطية بنجاح',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          action: SettingsAction.none,
          errorMessage: 'تعذر رفع النسخة الاحتياطية',
        ),
      );
    }
  }

  Future<void> restoreBackup() async {
    emit(
      state.copyWith(
        isLoading: true,
        action: SettingsAction.restore,
        clearMessages: true,
      ),
    );

    try {
      final metadata = await restoreBackupUseCase();
      await onBackupRestored?.call();

      emit(
        state.copyWith(
          metadata: metadata,
          isLoading: false,
          action: SettingsAction.none,
          successMessage: 'تم استبدال قاعدة البيانات بالنسخة الاحتياطية',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          action: SettingsAction.none,
          errorMessage: 'تعذر استعادة النسخة الاحتياطية',
        ),
      );
    }
  }
}
