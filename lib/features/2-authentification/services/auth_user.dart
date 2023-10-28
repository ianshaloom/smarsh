import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:smarsh/constants/hive_constants.dart';


class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String? name;
  final String? photoURL;





  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    this.name,
    this.photoURL,
  });


    static const AuthUser empty = AuthUser(
    id: '',
    email: '',
    isEmailVerified: false,
    name: '',
    photoURL: '',
  );


    bool get isEmpty => this == AuthUser.empty;

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
        name: user.displayName ?? 'Stranger',
        photoURL: user.photoURL ?? profilePhotoUrl,
      );
}
