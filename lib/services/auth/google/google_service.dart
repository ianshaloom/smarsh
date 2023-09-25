import 'google_auth_provider.dart';
import 'google_provider.dart';
import 'google_user.dart';

class GoogleService implements GoogleProvider {
  final GoogleProvider provider;
  const GoogleService(this.provider);

  factory GoogleService.google() => GoogleService(GoogleAuthProvida());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  GoogleUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<GoogleUser> signInWithGoogle() => provider.signInWithGoogle();
}
