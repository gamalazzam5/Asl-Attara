import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<AuthUserEntity> signUp({
    required String email,
    required String password,
  });

  Future<AuthUserEntity> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> resetPassword({required String email});

  Future<AuthUserEntity?> getCurrentUser();
}
