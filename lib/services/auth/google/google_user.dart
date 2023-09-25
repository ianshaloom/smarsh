import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class GoogleUser {
  
  final String url;
  final String name;
  final String email;
  final bool isEmailVerified;

  const GoogleUser({
    required this.url,
    required this.name,
    required this.email,
    required this.isEmailVerified,
  });

  factory GoogleUser.fromFirebase(User user) => GoogleUser(
        url: user.photoURL!,
        name: user.displayName!,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
