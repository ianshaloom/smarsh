import 'package:flutter/material.dart';

import 'auth_widgets.dart';


// SECTION: Forgot Password Page
/* -------------------------------------------------------------------------- */
class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final Function? onSendResetLinkPressed;

  const ForgotPasswordPage({
    super.key,
    required this.emailController,
    required this.formKey,
    required this.onSendResetLinkPressed,
  });

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
                        onPressed: () => onSendResetLinkPressed!(),
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
}
/* -------------------------------------------------------------------------- */
// !SECTION: Forgot Password Page
