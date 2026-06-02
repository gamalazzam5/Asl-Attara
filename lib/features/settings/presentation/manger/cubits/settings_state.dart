import '../../../../../core/services/backup_service.dart';

enum SettingsAction { none, upload, restore }

class SettingsState {
  final BackupMetadata? metadata;
  final bool isLoading;
  final SettingsAction action;
  final String? successMessage;
  final String? errorMessage;

  const SettingsState({
    this.metadata,
    this.isLoading = false,
    this.action = SettingsAction.none,
    this.successMessage,
    this.errorMessage,
  });

  const SettingsState.initial() : this();

  SettingsState copyWith({
    BackupMetadata? metadata,
    bool? isLoading,
    SettingsAction? action,
    String? successMessage,
    String? errorMessage,
    bool clearMessages = false,
  }) {
    return SettingsState(
      metadata: metadata ?? this.metadata,
      isLoading: isLoading ?? this.isLoading,
      action: action ?? this.action,
      successMessage: clearMessages ? null : successMessage,
      errorMessage: clearMessages ? null : errorMessage,
    );
  }
}
