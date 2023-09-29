import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 4)
class HiveUser extends HiveObject{
  @HiveField(0)
 String? url = 'https://ianshaloom.github.io/assets/img/perfil.png';
 
 @HiveField(1)
 String? name = 'Stranger';
 
 @HiveField(2)
 String? email;
 
 @HiveField(3)
bool? isEmailVerified;

@HiveField(4)
bool isGoogleSignIn;

@HiveField(5)
String? uid;

// @HiveField(4)
// boo

HiveUser({
  this.uid,
  this.url,
  this.name,
  this.email,
  this.isEmailVerified,
  required this.isGoogleSignIn,
});

}