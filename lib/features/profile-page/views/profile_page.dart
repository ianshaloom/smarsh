// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../global/helpers/snacks.dart';
import '../../2-Authentification/2-authentification/services/auth_service.dart';
import '../../2-Authentification/2-authentification/services/auth_user.dart';
import '../../2-Authentification/3-google-auth/services/google_service.dart';
import '../../../services/cloud/cloud_product.dart';
import '../widgets/check_new_update.dart';

class ProfilePage extends StatefulWidget {
  final CloudUser cloudUser;
  const ProfilePage({super.key, required this.cloudUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit_rounded),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Builder(builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.cloudUser.url, scale: 1),
                    radius: 50,
                  ),
                ),
                const SizedBox(height: 10),
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
                  subtitle: Text(widget.cloudUser.username),
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
                  subtitle: Text(widget.cloudUser.email),
                ),
                ListTile(
                  leading: const SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 30,
                    ),
                  ),
                  title: const Text('User Role'),
                  subtitle: Text(widget.cloudUser.role),
                ),
                // change password button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FilledButton.tonal(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    child: const Text('Change Password'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: FilledButton.tonal(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.errorContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    child: const Text('Delete Account'),
                  ),
                ),
              ],
            ),

            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: FilledButton(
                    onPressed: () {
                      _logOutDialog(context);
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    child: const Text('Sign Out'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _checkNewUpdateDialog();
                  },
                  child: const Text(
                    'Check for Updates',
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            )

            // delete account button
          ],
        );
      }),
    );
  }

  void _logOutDialog(BuildContext cxt) async {
    final bool confirm = await showDialog(
      context: cxt,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      await _logOut();
    }
  }

  void _checkNewUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const UpdateWidgetDialog();
      },
    );
  }

  Future<void> _logOut() async {
    if (widget.cloudUser.signInProvider == 'google') {
      await GoogleService.google().logOut();
      await AuthService.firebase().logOut();
    } else {
      await AuthService.firebase().logOut();
    }
    final user = AppService.firebase().currentUser;

    if (user == AuthUser.empty) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Snack().showSnackBar(context: context, message: 'Error Logging Out');
    }
  }
}
