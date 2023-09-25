import 'auth_user.dart';


// NOTE: This is the abstract class that for the AuthProvider of email and password
abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}

//NOTE - This is the abstract class for Firebase App Instance
abstract class MyFirebaseApp {
  Stream<AuthUser> get authStateChanges;
   AuthUser? get currentUser;
  Future<void> initialize();
}
