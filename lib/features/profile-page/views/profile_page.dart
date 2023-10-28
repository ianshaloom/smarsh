// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../constants/hive_constants.dart';
import '../../../global/helpers/snacks.dart';
import '../../2-authentification/services/auth_service.dart';
import '../../2-authentification/services/auth_user.dart';
import '../../3-google-auth/services/google_service.dart';
import '../../../services/cloud/cloud_product.dart';

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
                backgroundImage: NetworkImage(widget.cloudUser.url, scale: 1),
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
                ),
                child: const Text('Change Password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size.fromHeight(60),
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
    if (widget.cloudUser.url != profilePhotoUrl) {
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
