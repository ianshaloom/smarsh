// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/firebase_cloud_storage.dart';
import '../../3-google-auth/widgets/google_signin.dart';
import '../../../../global/helpers/snacks.dart';
import '../../auth_exceptions.dart';
import '../../constants.dart';
import '../../model/auth_user_entity.dart';
import '../provider/auth_provider.dart';
import 'forgot_password_page.dart';
import '../widgets/auth_widgets.dart';

//SECTION: Login Page
/* -------------------------------------------------------------------------- */
class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            //elevation: Elevation.none,
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Hi, Welcome Back'),
            titleTextStyle: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                emailController.clear();
                passwordController.clear();
                Navigator.pop(context);
              },
            ),
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(30.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please enter your detail.',
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    EmailTextFormField(controller: emailController),
                    const SizedBox(height: 25),
                    PassWordTextFormField(controller: passwordController),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(),
                            )),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        final form = formKey.currentState!;

                        if (form.validate()) {
                          final String email = emailController.text.trim();
                          final String password =
                              passwordController.text.trim();

                          _signIn(context, email, password);
                        }
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
                      child: const Text(
                        'Sign In',
                      ),
                    ),
                    const Column(
                      children: [
                        SizedBox(height: 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('or continue with'),
                            ),
                            Expanded(
                              child: Divider(),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        GoSignInWidget(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Login Page Members
  Future _signIn(BuildContext context, String email, String password) async {
    clearControllers(emailController, passwordController);
    showDialog(
      barrierColor: Colors.black38,
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: SizedBox(
          height: 75,
          width: 75,
          child: CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );

    try {
      final user = await AuthProvider()
          .signInWithEmailAndPassword(email: email, password: password);

      if (user == AuthUser.empty) {
        _instance.authError(6, context);
      } else if (user != AuthUser.empty && !user.isEmailVerified) {
        Navigator.popUntil(context, (route) => route.isFirst);
        _fromAuth(
          user.name!,
          user.email,
          user.id,
          context,
        );
        return user;
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
        _fromAuth(
          user.name!,
          user.email,
          user.id,
          context,
        );
        return user;
      }
    } on UserNotFoundAuthException {
      _instance.authError(0, context);
    } on WrongPasswordAuthException {
      _instance.authError(1, context);
    } on GenericAuthException {
      _instance.authError(6, context);
    }
  }

  Future _fromAuth(
    String username,
    String email,
    String uid,
    BuildContext context,
  ) async {
    try {
      final cloudUser = await FirebaseCloudUsers().singleUser(documentId: uid);

      if (cloudUser == null) {
        await FirebaseCloudUsers().createUser(
          userId: uid,
          username: username,
          email: email,
          role: 'user',
          url: authUserProfilePicture,
          provider: 'email&pass',
          color: 'green',
        );
      } else if (cloudUser.signInProvider != 'email&pass') {
        await FirebaseCloudUsers().updateUser(
          userId: uid,
          username: username,
          email: email,
          role: cloudUser.role,
          url: cloudUser.url,
          provider: 'email&pass',
          color: cloudUser.color,
        );
      }
    } on CouldNotCreateException {
      _instance.cloudError(1, context);
    }
  }
/* -------------------------------------------------------------------------- */

// clear controllers
  void clearControllers(TextEditingController emailController,
      TextEditingController passwordController) {
    emailController.clear();
    passwordController.clear();
  }
}

final Snack _instance = Snack();
/* -------------------------------------------------------------------------- */
//!SECTION: Login Page
