import '../../model/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthUserModel?> get user;

  Future<AuthUserModel> signUp({
    required String email,
    required String password,
  });

  Future<AuthUserModel> signIn({
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
  Future<AuthUserModel> changeEmail({
    required String email,
  });

  // change password
  Future<AuthUserModel> changePassword({
    required String password,
  });

  // delete account
  Future<void> deleteAccount();

  // sign out
  Future<void> signOut();
}
