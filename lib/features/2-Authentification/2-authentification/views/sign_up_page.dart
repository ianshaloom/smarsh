// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smarsh/features/2-Authentification/model/auth_user_entity.dart';

import '../../../../services/hive/service/hive_constants.dart';
import '../../3-google-auth/widgets/google_signin.dart';
import '../../../../global/helpers/snacks.dart';
import '../../auth_exceptions.dart';
import '../provider/auth_provider.dart';
import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/firebase_cloud_storage.dart';
import '../widgets/auth_widgets.dart';

// SECTION: Register Page
/* -------------------------------------------------------------------------- */
class SignUpPage extends StatelessWidget {
  SignUpPage({
    super.key,
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
            onPressed: () async {
              FocusScope.of(context).unfocus();
              final form = formKey.currentState!;

              if (form.validate()) {
                final String fullName = fullNameController.text.trim();
                final String email = emailController.text.trim();
                final String password = passwordController.text.trim();

                await _signUp(context, fullName, email, password);

                fullNameController.clear();
                emailController.clear();
                passwordController.clear();
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
          const GoSignInWidget(),
        ],
      ),
    );
  }

/* -------------------------- Sign Up Page Members ------------------------- */
  Future _signUp(
    BuildContext context,
    String fullname,
    String email,
    String password,
  ) async {
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
          .signUpWithEmailAndPassword(email: email, password: password);

      if (user == AuthUser.empty) {
        _instance.authError(6, context);
      } else {
        _fromAuth(fullname, email, user.id, context);
        await AuthProvider().verifyEmail();
        Navigator.popUntil(context, (route) => route.isFirst);
        return user;
      }
    } on WeakPasswordAuthException {
      _instance.authError(3, context);
    } on EmailAlreadyInUseAuthException {
      _instance.authError(4, context);
    } on InvalidEmailAuthException {
      _instance.authError(1, context);
    } on GenericAuthException {
      _instance.authError(6, context);
    }
  }

  /* -------------------------------------------------------------------------- */

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
            url: profilePhotoUrl,
            provider: 'email&pass',
            color: 'green');
      } else if (cloudUser.signInProvider != 'email&pass') {
        await FirebaseCloudUsers().updateUser(
          userId: uid,
          username: username,
          email: email,
          role: cloudUser.role,
          url: profilePhotoUrl,
          provider: 'email&pass',
          color: cloudUser.color,
        );
      }
    } on CouldNotCreateException {
      _instance.cloudError(1, context);
    }
  }
}
/* -------------------------------------------------------------------------- */
// !SECTION: Register Page

final Snack _instance = Snack();
