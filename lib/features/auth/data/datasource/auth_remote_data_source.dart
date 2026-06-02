import 'package:firebase_auth/firebase_auth.dart';

import '../models/auth_user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSource({FirebaseAuth? firebaseAuth})
    : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AuthUserModel> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'تعذر إنشاء الحساب',
      );
    }

    return AuthUserModel.fromFirebaseUser(user);
  }

  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'تعذر تسجيل الدخول',
      );
    }

    return AuthUserModel.fromFirebaseUser(user);
  }

  Future<void> signOut() => firebaseAuth.signOut();

  Future<void> resetPassword({required String email}) {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<AuthUserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    return AuthUserModel.fromFirebaseUser(user);
  }
}
