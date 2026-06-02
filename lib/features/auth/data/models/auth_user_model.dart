import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({required super.uid, required super.email});

  factory AuthUserModel.fromFirebaseUser(User user) {
    return AuthUserModel(uid: user.uid, email: user.email);
  }
}
