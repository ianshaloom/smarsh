import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth_widgets.dart';

//SECTION: Login Page
/* -------------------------------------------------------------------------- */
class SignInPage extends StatefulWidget {
  final Function onSignInPressed;
  final Function onForgotPasswordPressed;
  final Function onGoogleSignInPressed;

  const SignInPage({
    super.key,
    required this.onSignInPressed,
    required this.onForgotPasswordPressed,
    required this.onGoogleSignInPressed,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
                        onPressed: () => widget.onForgotPasswordPressed(),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        _onPressed();
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
                    const SizedBox(height: 70),
                    const Row(
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
                    const SizedBox(height: 15),
                    FilledButton.tonal(
                      onPressed: () => widget.onGoogleSignInPressed(),
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

  void _onPressed() async {
    final form = formKey.currentState!;

    if (form.validate()) {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      widget.onSignInPressed(email, password);
    }
  }
}
/* -------------------------------------------------------------------------- */
//!SECTION: Login Page
