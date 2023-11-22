import '../../model/auth_user_entity.dart';

abstract class AuthRepository {

  Stream<AuthUser> get authUser;

  Future<AuthUser> signUp({
    required String email,
    required String password,
  });

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  // send password reset email
  Future<void> sendPasswordResetEmail({
    required String email,
  });

  // send email verification email
  Future<void> sendEmailVerification();

  // change email
  Future<AuthUser> changeEmail({
    required String email,
  });

  // change password
  Future<AuthUser> changePassword({
    required String password,
  });

  // delete account
  Future<void> deleteAccount();

  // sign out
  Future<void> signOut();
}
