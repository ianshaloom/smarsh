// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smarsh/global/helpers/snacks.dart';

import '../../2-authentification/services/auth_exceptions.dart';
import '../../2-authentification/services/auth_service.dart';
import '../../2-authentification/views/forgot_password_page.dart';
import '../../2-authentification/views/login_page.dart';
import '../../2-authentification/views/sign_up_page.dart';

// SECTION: Landing Page
/* -------------------------------------------------------------------------- */
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    Brightness brightness = Theme.of(context).brightness;

    debugPrint('*** ===============I was mounted =============== ***');
    return Scaffold(
      // app bar prevent status bar from being transparent
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            //flex: 9,
            child: Center(
              child: SvgPicture.asset(
                brightness == Brightness.dark
                    ? 'assets/images/logo-dark.svg'
                    : 'assets/images/logo-light.svg',
              ),
            ),
          ),
          Container(
            color: colorScheme.surface,
            height: 200,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: 50,
                width: screenSize.width * 0.7,
                child: _buildPageButtons(context),
              ),
            ),
          )
        ],
      ),
    );
  }

/* --------------------------- Login Page Members --------------------------- */

  void _toForgotPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordPage(
          onSendResetLinkPressed: _reset,
        ),
      ),
    );
  }

  void _toLandingPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingPage(),
      ),
      ((route) => route.isFirst),
    );
  }
/* -------------------------------------------------------------------------- */

/* -------------------------- Forgot Password Page -------------------------- */

  void _reset() async {}

  // NOTE Send Password Reset Link
  Future _sendPasswordResetLink(String email) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text('Sending Reset Link...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      await AuthService.firebase().sendPasswordReset(toEmail: email);
      _toLandingPage();
    } on UserNotFoundAuthException {
      _instance.authError(0, context);
    } on GenericAuthException {
      _instance.authError(6, context);
    }
  }

/* -------------------------------------------------------------------------- */
  //  NOTE Landing Page Widgets
  Widget _buildPageButtons(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignInPage(
                  onForgotPasswordPressed: _toForgotPasswordPage,
                ),
              ),
            ),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size.fromHeight(60),
              textStyle: textTheme.labelLarge!.copyWith(
                fontSize: 17,
              ),
            ),
            child: const Text(
              'Login',
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpPage(),
              ),
            ),
            //onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: textTheme.labelLarge!.copyWith(
                fontSize: 17,
              ),
              minimumSize: const Size.fromHeight(60),
            ),
            child: const Text(
              'Sign Up',
            ),
          ),
        ),
      ],
    );
  }
}

Snack _instance = Snack();
/* -------------------------------------------------------------------------- */
//!SECTION: Landing Page

