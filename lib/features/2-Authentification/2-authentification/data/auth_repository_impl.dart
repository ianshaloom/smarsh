import '../../model/auth_user_entity.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  // user stream
  @override
  Stream<AuthUser> get authUser {
    return remoteDataSource.user.map((authUserModel) {
      return authUserModel == null ? AuthUser.empty : authUserModel.toEntity();
    });
  }

  // sign up
  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    final authUserModel = await remoteDataSource.signUp(
      email: email,
      password: password,
    );
    return authUserModel.toEntity();
  }

  // sign in
  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final authUserModel = await remoteDataSource.signIn(
      email: email,
      password: password,
    );
    return authUserModel.toEntity();
  }

  // send password reset email
  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await remoteDataSource.sendPasswordResetEmail(email: email);
  }

  // send email verification email
  @override
  Future<void> sendEmailVerification() async {
    await remoteDataSource.sendEmailVerification();
  }

  // change email
  @override
  Future<AuthUser> changeEmail({
    required String email,
  }) async {
    final authUserModel = await remoteDataSource.changeEmail(email: email);

    return authUserModel.toEntity();
  }

  // change password
  @override
  Future<AuthUser> changePassword({
    required String password,
  }) async {
    final authUserModel =
        await remoteDataSource.changePassword(password: password);

    return authUserModel.toEntity();
  }

  // delete account
  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteAccount();
  }

  // sign out
  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }
}
