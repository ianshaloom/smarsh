import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, GoogleAuthProvider;
import 'package:google_sign_in/google_sign_in.dart';

import '../../firebase_options.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

// NOTE: This is the implementation of the AuthProvider interface for Firebase Auth.

class FirebaseAuthProvida implements AuthProvider {
  FirebaseAuthProvida._();
  static final instance = FirebaseAuthProvida._();
  factory FirebaseAuthProvida() => instance;

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      print('ERROR CODE: ${e.code}');
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}

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
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
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
        print('nOTIFY LISTENERS =====================>>> sIGN IN');
        print('Welcome : ${user.name}');
        print('Welcome : ${user.isEmailVerified}');
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
    } catch (_) {
      throw GenericAuthException();
    }
  }
}

//NOTE - This is the implementation of the MyFirebaseApp interface for Firebase App Instance

class MyFirebaseAppImpl implements MyFirebaseApp {
  MyFirebaseAppImpl._();
  static final instance = MyFirebaseAppImpl._();
  factory MyFirebaseAppImpl() => instance;

  @override
  Stream<AuthUser> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges().map((user) {
        if (user != null) {
          return AuthUser.fromFirebase(user);
        } else {
          throw UserNotLoggedInAuthException();
        }
      });
}
