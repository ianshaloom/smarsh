import 'package:flutter/material.dart';
import 'package:smarsh/services/hive/models/user_model/user_model.dart';

import '../auth-views/landing_page.dart';
import '../../constants/hive_constants.dart';
import '../../services/auth/email_n_password/auth_service.dart';
import '../../services/auth/google/google_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = GetMeFromHive.getHiveUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    _logOutDialog(context);
                  },
                ),
              ],
            ),
            body: Builder(builder: (context) {
              return ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user!.url!, scale: 1),
                      radius: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.person_outline,
                        size: 30,
                      ),
                    ),
                    title: const Text('Name'),
                    subtitle: Text(user!.name!),
                  ),
                  ListTile(
                    leading: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.email_rounded,
                        size: 30,
                      ),
                    ),
                    title: const Text('Email'),
                    subtitle: Text(user!.email!),
                  ),
                  ListTile(
                    leading: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.lock_person_outlined,
                        size: 30,
                      ),
                    ),
                    title: const Text('Account Type'),
                    subtitle: const Text('User'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _adminProfile(context),
                    ),
                  ),
                  // change password button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(60),
                        textStyle:
                            Theme.of(context).textTheme.labelLarge!.copyWith(
                                  fontSize: 17,
                                ),
                      ),
                      child: const Text('Change Password'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(60),
                        textStyle:
                            Theme.of(context).textTheme.labelLarge!.copyWith(
                                  fontSize: 17,
                                ),
                      ),
                      child: const Text('Delete Account'),
                    ),
                  ),
                  // delete account button
                ],
              );
            }),
          );
  }

  void _adminProfile(BuildContext cxt) {
    showBottomSheet(
      context: cxt,
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        height: 70,
        child: Row(
          children: [
            Expanded(
              child: FilledButton.tonal(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size.fromHeight(40),
                  textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 17,
                      ),
                ),
                child: const Text('User'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () => _switchToAdmin(context),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size.fromHeight(40),
                  textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 17,
                      ),
                ),
                child: const Text('Admin'),
              ),
            )
          ],
        ),
      ),
    );
  }

  final passController = TextEditingController();
  void _switchToAdmin(BuildContext cxt) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        context: cxt,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        builder: (context) => Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 10,
              ),
              //height: 100,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15.0, right: 4),
                child: Row(
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        child: TextField(
                          controller: passController,
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        if (passController.text == 'admin') {
                          Navigator.of(context).pop();
                          _adminProfile(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ));
  }

  void _logOutDialog(BuildContext cxt) {
    showDialog(
        context: cxt,
        builder: (context) => AlertDialog(
              title: const Text('Log Out'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                    onPressed: () {
                      _logOut();
                    },
                    child: const Text('Yes')),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('No'),
                ),
              ],
            ));
  }

  Future<void> _logOut() async {
    // Update User Profile in Hive
    HiveUser userHive = GetMeFromHive.getHiveUser!;

    if (userHive.isGoogleSignIn) {
      print('HEH !!!! =====================>>> GOOGLE sIGN OUT');
      await GoogleService.google().logOut();
      await AuthService.firebase().logOut();
    } else {
      print(userHive.isGoogleSignIn);
      print('HEH !!!! =====================>>> OUT');
      await AuthService.firebase().logOut();
    }

    userHive.email = 'info@smarsh.com';
    userHive.name = 'Stranger';
    userHive.url = 'https://ianshaloom.github.io/assets/img/perfil.png';
    userHive.isGoogleSignIn = false;
    userHive.isEmailVerified = false;

    await userHive.save();
    final user = AppService.firebase().currentUser;
    user == null ? _toLandingPage() : debugPrint(user.email);
  }

  void _toLandingPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingPage(),
      ),
      (route) => route.isFirst,
    );
  }


}
