import 'google_user.dart';

//NOTE - This is the abstract class for the AuthProvider of Google
abstract class GoogleProvider {
  Future<void> initialize();

  GoogleUser? get currentUser;

  Future<GoogleUser> signInWithGoogle();
  Future<void> logOut();
}


