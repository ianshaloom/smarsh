// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/firebase_cloud_storage.dart';
import '../../auth_exceptions.dart';
import '../services/google_service.dart';
import '../services/google_user.dart';

class GoSignInWidget extends StatefulWidget {
  const GoSignInWidget({super.key});

  @override
  State<GoSignInWidget> createState() => _GoSignInWidgetState();
}

class _GoSignInWidgetState extends State<GoSignInWidget> {
  bool isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return isSigningIn
        ? Center(
            child: Container(
              height: 45,
              width: 45,
              margin: const EdgeInsets.only(top: 50),
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : FilledButton.tonal(
            onPressed: () {
              setState(() {
                isSigningIn = true;
              });
              _toSignInWithGoogle(context).whenComplete(() => setState(() {
                    isSigningIn = false;
                  }));
            },
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size.fromHeight(60),
              textStyle: textTheme.labelLarge!.copyWith(
                fontSize: 17,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/icons/google.svg',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 20),
                Text(
                  'Continue with Google',
                  style: textTheme.labelLarge!.copyWith(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          );
  }

  Future _toSignInWithGoogle(BuildContext context) async {
    if (isSigningIn) {
      try {
        final user = await GoogleService.google().signInWithGoogle();
        _fromGoogle(user, context);
        Navigator.popUntil(context, (route) => route.isFirst);
        //return user;
      } on UserNotFoundAuthException {
        _instance.authError(1, context);
      } on GenericAuthException {
        _instance.authError(6, context);
      }
    }
  }

  Future _fromGoogle(GoogleUser? googleUser, BuildContext context) async {
    final String giD = googleUser!.id;

    try {
      final cloudUser = await FirebaseCloudUsers().singleUser(documentId: giD);

      if (cloudUser == null) {
        await FirebaseCloudUsers().createUser(
          userId: giD,
          username: googleUser.name,
          email: googleUser.email,
          role: 'user',
          url: googleUser.url,
          provider: 'google',
        );
      } else if (cloudUser.signInProvider != 'google') {
        await FirebaseCloudUsers().updateUser(
          userId: giD,
          username: googleUser.name,
          email: googleUser.email,
          role: cloudUser.role,
          url: googleUser.url,
          provider: 'google',
        );
      }
    } on CouldNotCreateException {
      _instance.authError(1, context);
    } on GenericAuthException {
      _instance.authError(4, context);
    }
  }

  final Snack _instance = Snack();
}
