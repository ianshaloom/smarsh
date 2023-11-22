import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../constants.dart';
import 'auth_user_entity.dart';

class AuthUserModel extends Equatable {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String? name;
  final String? photoURL;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    this.name,
    this.photoURL,
  });

  factory AuthUserModel.fromFirebaseAuthUser(
    firebase_auth.User firebaseUser,
  ) {
    return AuthUserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      isEmailVerified: firebaseUser.emailVerified,
      name: firebaseUser.displayName ?? 'Stranger',
      photoURL: firebaseUser.photoURL ?? authUserProfilePicture,
    );
  }

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      isEmailVerified: isEmailVerified,
      name: name ?? 'Stranger',
      photoUrl: photoURL ?? authUserProfilePicture,
    );
  }

  @override
  List<Object?> get props => [id, email, isEmailVerified, name, photoURL];
}
