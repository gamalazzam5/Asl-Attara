import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthUserEntity> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await remoteDataSource.signUp(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthMessage(e));
    }
  }

  @override
  Future<AuthUserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await remoteDataSource.signIn(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthMessage(e));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthMessage(e));
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await remoteDataSource.resetPassword(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthMessage(e));
    }
  }

  @override
  Future<AuthUserEntity?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  String _mapFirebaseAuthMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';
      case 'wrong-password':
      case 'invalid-credential':
        return 'بيانات الدخول غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة';
      case 'network-request-failed':
        return 'تحقق من الاتصال بالإنترنت';
      default:
        return exception.message ?? 'حدث خطأ غير متوقع';
    }
  }
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}
