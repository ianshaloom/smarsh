import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/hive_constants.dart';
import '../../services/auth/email_n_password/auth_exceptions.dart';
import '../../services/auth/email_n_password/auth_service.dart';
import '../../services/auth/google/google_service.dart';
import '../../services/hive/models/user_model/user_model.dart';
import '../../services/hive/service/hive_service.dart';
import '../../utils/shared_classes.dart';
import '../../utils/snackbar.dart';
import 'forgot_password_page.dart';
import 'login_page.dart';
import 'sign_up_page.dart';
import 'verify_email_page.dart';
import '../homepage-views/home_page.dart';

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

  void add() async {
    await HiveUserService().deleteAllUsers();
    final String id = Processors.generateCode(20);

    HiveUser hiveUser = HiveUser(
      uid: id,
      url: 'https://ianshaloom.github.io/assets/img/perfil.png',
      name: 'Stranger',
      email: 'info@smarsh.com',
      isEmailVerified: false,
      isGoogleSignIn: false,
    );

    await HiveUserService().addUser(hiveUser);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    //debugPrint('SUrface: ${colorScheme.surface}');
    Brightness brightness = Theme.of(context).brightness;

    debugPrint('Screen Size: ${colorScheme.primary}');
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
// Login Page Members
  Future _signIn(String email, String password) async {
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
                Text('Loging In...'),
              ],
            ),
              
          ),
        ),
      ),
    );

    try {
      await AuthService.firebase().logIn(
        email: email,
        password: password,
      );

      final user = AppService.firebase().currentUser;

      if (user == null) {
        return (4);
      } else if (!user.isEmailVerified) {
        _toVerifyEmailPage();
        return user;
      } else {
        HiveUser? userHive = GetMeFromHive.getHiveUser;

        userHive!.email = user.email;
        userHive.name = 'Stranger';
        userHive.url = 'https://ianshaloom.github.io/assets/img/perfil.png';
        userHive.isGoogleSignIn = false;
        userHive.isEmailVerified = true;

        await userHive.save();

        _toHomePage();
        return user;
      }
    } on UserNotFoundAuthException {
      _error(6);
    } on WrongPasswordAuthException {
      _error(1);
    } on GenericAuthException {
      _error(7);
    }
  }

  Future _toSignInWithGoogle() async {
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
                Text('Signing Up...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final user = await GoogleService.google().signInWithGoogle();

      HiveUser userHive = GetMeFromHive.getHiveUser!;

      userHive.email = user.email;
      userHive.name = user.name;
      userHive.url = user.url;
      userHive.isGoogleSignIn = true;
      userHive.isEmailVerified = true;

      await userHive.save();
      _popContext();
      _toHomePage();
      //return user;
    } on UserNotFoundAuthException {
      _error(6);
    } on GenericAuthException {
      _error(7);
    }
  }

/* -------------------------------------------------------------------------- */

/* -------------------------- Sign Up Page Members ------------------------- */
  Future _signUp(String email, String password) async {
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
                Text('Signing Up...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      await AuthService.firebase().createUser(
        email: email,
        password: password,
      );
      await AuthService.firebase().sendEmailVerification();
      _toVerifyEmailPage();
    } on WeakPasswordAuthException {
      _error(3);
    } on EmailAlreadyInUseAuthException {
      _error(4);
    } on InvalidEmailAuthException {
      _error(5);
    } on GenericAuthException {
      _error(7);
    }
  }

  // -- /* ------------------Navigations---------------- */ -- //
  void _toVerifyEmailPage() {
    Navigator.of(context).pop();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const VerifyEmailPage(),
      ),
      ((route) => route.isFirst),
    );
  }

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

  void _popContext() {
    Navigator.of(context).pop();
  }

  void _toHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      ((route) => route.isFirst),
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
      _error(0);
      _toLandingPage();
    } on UserNotFoundAuthException {
      _error(6);
    } on GenericAuthException {
      _error(7);
    }
  }

  // NOTE Error Handling
  void _error(int index) {
    switch (index) {
      case 0:
        {
          Navigator.pop(context);
          ErrorUtil.showSnackBar(context: context, message: 'User not found');
        }
        break;
      case 1:
        {
          Navigator.pop(context);
          ErrorUtil.showSnackBar(
              context: context, message: 'Invalid Login Credentials');
        }
        break;
      case 2:
        {
          Navigator.pop(context);
          ErrorUtil.showSnackBar(
              context: context, message: 'Authentication failed');
        }
        break;
      case 3:
        {
          Navigator.pop(context);
          ErrorUtil.showSnackBar(
              context: context, message: 'Password is too weak');
        }
        break;

      case 4:
        {
          Navigator.pop(context);
          ErrorUtil.showSnackBar(
              context: context, message: 'Email already in use');
        }
        break;

      case 5:
        {
          Navigator.pop(context);
          ErrorUtil.showSnackBar(
              context: context, message: 'Password is too weak');
        }
        break;

      case 6:
        {
          Navigator.pop(context);
          ErrorUtil.showSnackBar(context: context, message: 'User not found');
        }
        break;

      case 7:
        {
          Navigator.pop(context);
          ErrorUtil.showSnackBar(
              context: context, message: 'Something went wrong');
        }
        break;
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
                  onSignInPressed: _signIn,
                  onForgotPasswordPressed: _toForgotPasswordPage,
                  onGoogleSignInPressed: _toSignInWithGoogle,
                ),
              ),
            ),
            // onPressed: () async {
            //   //final user = AuthService.firebase().currentUser;
            //   //print(user!.name);
            //   await _signIn('ianshaloom0@gmail.com', 'zxcvbnm,.');
            //   //await AuthService.firebase().logOut();
            // },
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
                builder: (context) => SignUpPage(
                  onSignUpPressed: _signUp,
                  onGoogleSignUpPressed: _toSignInWithGoogle,
                ),
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

/* -------------------------------------------------------------------------- */
//!SECTION: Landing Page

