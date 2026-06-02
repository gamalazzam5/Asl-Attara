import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/get_current_user_use_case.dart';
import '../../domain/usecases/reset_password_use_case.dart';
import '../../domain/usecases/sign_in_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';
import '../../domain/usecases/sign_up_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit(
    this.signUpUseCase,
    this.signInUseCase,
    this.signOutUseCase,
    this.resetPasswordUseCase,
    this.getCurrentUserUseCase,
  ) : super(const AuthInitial());

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final user = await signUpUseCase(email: email, password: password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_readMessage(e)));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());

    try {
      final user = await signInUseCase(email: email, password: password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_readMessage(e)));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());

    try {
      await signOutUseCase();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(_readMessage(e)));
    }
  }

  Future<void> forgotPassword({required String email}) async {
    emit(const AuthLoading());

    try {
      await resetPasswordUseCase(email: email);
      emit(const PasswordResetSent());
    } catch (e) {
      emit(AuthError(_readMessage(e)));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());

    try {
      final user = await getCurrentUserUseCase();
      if (user == null) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError(_readMessage(e)));
    }
  }

  String _readMessage(Object error) {
    if (error is AuthException) return error.message;
    return 'حدث خطأ غير متوقع';
  }
}
