
import '../../model/auth_user_entity.dart';
import '../data/auth_remote_data_source_firebase.dart';
import '../data/auth_repository_impl.dart';

class AuthProvider {
  static final AuthRepositoryImpl _authRepositoryImpl =
      AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceFirebase());

  Stream<AuthUser> get currentUser {
    return _authRepositoryImpl.authUser;
  }

  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    AuthUser user = await _authRepositoryImpl.signIn(
      email: email,
      password: password,
    );

    return user;
  }

  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    AuthUser user = await _authRepositoryImpl.signUp(
      email: email,
      password: password,
    );

    return user;
  }

  Future<void> verifyEmail() async {
    await _authRepositoryImpl.sendEmailVerification();
  }

  Future<void> sendPasswordResetLink(String email) async {
    await _authRepositoryImpl.sendPasswordResetEmail(email: email);
  }

  Future<AuthUser> changePassword(String password) async {
    AuthUser user =
        await _authRepositoryImpl.changePassword(password: password);

    return user;
  }

  // change email
  Future<AuthUser> changeEmail(String email) async {
    AuthUser user = await _authRepositoryImpl.changeEmail(email: email);

    return user;
  }

  Future<void> signOut() async {
    await _authRepositoryImpl.signOut();
  }
}
