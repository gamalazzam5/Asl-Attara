import '../../domain/usecases/get_current_user_use_case.dart';

class AuthGuard {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthGuard(this.getCurrentUserUseCase);

  Future<bool> get isAuthenticated async {
    final user = await getCurrentUserUseCase();
    return user != null;
  }
}
