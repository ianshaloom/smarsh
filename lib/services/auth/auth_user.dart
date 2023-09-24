import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String url;
  final String name;
  final String email;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.url,
    required this.name,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        url: user.photoURL!,
        name: user.displayName!,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
