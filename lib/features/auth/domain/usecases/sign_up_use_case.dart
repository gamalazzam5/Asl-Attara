import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<AuthUserEntity> call({
    required String email,
    required String password,
  }) {
    return repository.signUp(email: email, password: password);
  }
}
