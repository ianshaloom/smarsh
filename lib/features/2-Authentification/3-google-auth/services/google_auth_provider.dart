import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../firebase_options.dart';
import '../../auth_exceptions.dart';
import 'google_provider.dart';
import 'google_user.dart';

// NOTE: This is the implementation of the AuthProvider interface for Google Auth.
class GoogleAuthProvida implements GoogleProvider {
  GoogleAuthProvida._();
  static final instance = GoogleAuthProvida._();
  factory GoogleAuthProvida() => instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount get user => _currentUser!;

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  GoogleUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return GoogleUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<GoogleUser> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) throw UserNotLoggedInAuthException();
      _currentUser = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = currentUser;

      if (user != null) {
        //notifyListeners();
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await googleSignIn.disconnect();
    } catch (e) {
      throw GenericAuthException();
    }
  }
}
