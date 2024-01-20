import 'package:flutter/material.dart';

import '../../../../global/helpers/snacks.dart';
import '../../auth_exceptions.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_widgets.dart';

// SECTION: Forgot Password Page
/* -------------------------------------------------------------------------- */
class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Forgot Password'),
            centerTitle: true,
            titleTextStyle: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                emailController.clear();
                Navigator.pop(context);
              },
            ),
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(55.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'No problem at all, enter your email '
                  'address to receive a password reset link',
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            // flexibleSpace: Align(
            //   alignment: Alignment.bottomLeft,
            //   child:
            // ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.03),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: formKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      EmailTextFormField(
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            final String email = emailController.text.trim();

                            _sendPasswordResetLink(email, context)
                                .then((value) {
                              if (value) {
                                emailController.clear();
                                Navigator.of(context).pop();
                                _instance.showSnackBar(
                                    context: context,
                                    message:
                                        'Password Reset Link Sent Successfully');
                              } else {
                                emailController.clear();
                                Navigator.of(context).pop();
                              }
                            }).onError((error, stackTrace) {
                              emailController.clear();
                              if (error == UserNotFoundAuthException) {
                                _instance.authError(0, context);
                              } else {
                                _instance.authError(6, context);
                              }
                            });
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
                          'Send Reset Link',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _sendPasswordResetLink(
      String email, BuildContext context) async {
    bool loginSuccess = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
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
      // cause an error

      await AuthProvider().sendPasswordResetLink(email).then((value) {
        loginSuccess = true;
      });
      return loginSuccess;
    } on UserNotFoundAuthException {
      return loginSuccess;
    } on GenericAuthException {
      return loginSuccess;
    }
  }
}

final Snack _instance = Snack();
/* -------------------------------------------------------------------------- */
// !SECTION: Forgot Password Page
