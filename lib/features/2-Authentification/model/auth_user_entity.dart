import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String? name;
  final String? photoUrl;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    this.name,
    this.photoUrl,
  });

  static const AuthUser empty = AuthUser(
    id: '',
    email: '',
    isEmailVerified: false,
    name: '',
    photoUrl: '',
  );

  bool get isEmpty => this == AuthUser.empty;

  @override
  List<Object?> get props => [id, name, isEmailVerified, email, photoUrl];
}
