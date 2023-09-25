import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth_widgets.dart';

// SECTION: Register Page
/* -------------------------------------------------------------------------- */
class SignUpPage extends StatelessWidget {
  final Function onSignUpPressed;
  final Function onGoogleSignUpPressed;

  SignUpPage({
    super.key,
    required this.onSignUpPressed,
    required this.onGoogleSignUpPressed,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Create Account'),
            titleTextStyle: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                fullNameController.clear();
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
                  'Please enter your details.',
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: _buildRegisterForm(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Form(
      key: formKey,
      child: Column(
        children: [
          NormalTextFormField(
            controller: fullNameController,
            needsValidation: true,
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            errorText: 'Please enter your full name',
            prefixIcon: const Icon(Icons.person_outline),
          ),
          const SizedBox(height: 15),
          EmailTextFormField(controller: emailController),
          const SizedBox(height: 15),
          PassWordTextFormField(controller: passwordController),
          const SizedBox(height: 15),
          FilledButton(
            onPressed: () => _onPressed(),
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
              'Sign Up',
            ),
          ),
          const SizedBox(height: 15),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'By creating an account,  you agree to our ',
                  style: textTheme.labelMedium,
                ),
                TextSpan(
                  text: ' Terms & Condition',
                  style: textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ' and ',
                  style: textTheme.labelMedium,
                ),
                TextSpan(
                  text: 'Privacy Policy.*',
                  style: textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
            onPressed: () => onGoogleSignUpPressed(),
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
                  'Sign up with Google',
                  style: textTheme.labelLarge!.copyWith(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onPressed() async {
    final form = formKey.currentState!;

    if (form.validate()) {
      final String fullName = fullNameController.text.trim();
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      await onSignUpPressed(email, password);

      fullNameController.clear();
      emailController.clear();
      passwordController.clear();
    }
  }
}
/* -------------------------------------------------------------------------- */
// !SECTION: Register Page
