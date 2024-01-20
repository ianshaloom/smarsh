// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../global/helpers/snacks.dart';
import '../../2-Authentification/2-authentification/services/auth_service.dart';
import '../../2-Authentification/2-authentification/services/auth_user.dart';
import '../../2-Authentification/3-google-auth/services/google_service.dart';
import '../../../services/cloud/cloud_entities.dart';
import '../../4-home-page/provider/homepage_provider.dart';
import '../services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String avatar = context.watch<ProfileProvida>().avatar;
    final CloudUser cloudUser = context.read<HomePageProvida>().getUser;

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
      ),
      body: Builder(builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 51.5,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          avatar == '' ? cloudUser.url : avatar,
                          scale: 1),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      radius: 50,
                    ),
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
                  subtitle: Text(cloudUser.username),
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
                  subtitle: Text(cloudUser.email),
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
                  subtitle: Text(cloudUser.role),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    // const Divider(),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Select Avatar',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...avatars.map((avatar) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () {
                                context.read<ProfileProvida>().updateAvatar(
                                      avatar,
                                      cloudUser.userId,
                                    );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(avatar, scale: 1),
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                radius: 30,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
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
                      _logOutDialog(context, cloudUser);
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
              ],
            )

            // delete account button
          ],
        );
      }),
    );
  }

  void _logOutDialog(BuildContext cxt, CloudUser cloudUser) async {
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
      await _logOut(cloudUser);
    }
  }

  Future<void> _logOut(CloudUser cloudUser) async {
    if (cloudUser.signInProvider == 'google') {
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
