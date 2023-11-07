
abstract class ProfileProvider {
  Future<void> updateProfile({String name, String email});
  Future<void> deleteProfile();
}
