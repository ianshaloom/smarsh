import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../auth_exceptions.dart';
import '../../model/auth_user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceFirebase implements AuthRemoteDataSource {
  //   AuthRemoteDataSourceFirebase({
  //   firebase_auth.FirebaseAuth? firebaseAuth,
  // }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  // get user
  @override
  Stream<AuthUserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser != null) {
        return AuthUserModel.fromFirebaseAuthUser(firebaseUser);
      } else {
        return null;
      }
    });
  }

  // sign up
  @override
  Future<AuthUserModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final firebase_auth.UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign up failed: The user is null after sign up.');
      }

      return AuthUserModel.fromFirebaseAuthUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'weak-password':
          throw WeakPasswordAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  // sign in
  @override
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final firebase_auth.UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign in failed: The user is null after sign in.');
      }

      return AuthUserModel.fromFirebaseAuthUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFoundAuthException();
        case 'wrong-password':
          throw WrongPasswordAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  // send password reset email
  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } on firebase_auth.FirebaseAuthException catch (_) {
      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  // send email verification email
  @override
  Future<void> sendEmailVerification() async {
    try {
      final firebase_auth.User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      } else {
        throw Exception('sendEmailVerification: The user is null.');
      }
    } on firebase_auth.FirebaseAuthException catch (_) {
      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  // change email
  @override
  Future<AuthUserModel> changeEmail({
    required String email,
  }) async {
    try {
      final firebase_auth.User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateEmail(email);
      } else {
        throw Exception('changeEmail: The user is null.');
      }

      return AuthUserModel.fromFirebaseAuthUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  // change password
  @override
  Future<AuthUserModel> changePassword({
    required String password,
  }) async {
    try {
      final firebase_auth.User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updatePassword(password);
      } else {
        throw Exception('changePassword: The user is null.');
      }

      return AuthUserModel.fromFirebaseAuthUser(user);
    } on firebase_auth.FirebaseAuthException catch (_) {
      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  // delete account
  @override
  Future<void> deleteAccount() async {
    try {
      final firebase_auth.User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        throw Exception('deleteAccount: The user is null.');
      }
    } on firebase_auth.FirebaseAuthException catch (_) {
      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  // sign out
  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase_auth.FirebaseAuthException catch (_) {
      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  // factory constructor
  AuthRemoteDataSourceFirebase._({
    required firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
  static final AuthRemoteDataSourceFirebase _instance =
      AuthRemoteDataSourceFirebase._(
    firebaseAuth: firebase_auth.FirebaseAuth.instance,
  );
  factory AuthRemoteDataSourceFirebase() => _instance;
}
