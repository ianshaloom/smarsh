import 'dart:async';

import 'package:email_validator/email_validator.dart' show EmailValidator;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'services/auth/auth_exceptions.dart';
import 'services/auth/auth_service.dart';
import 'views/homepage-views/home_page.dart';

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
  void dispose() {
    _emailControllerLogin.dispose();
    _passwordControllerLogin.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _emailControllerForgot.dispose();
    super.dispose();
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

  // Landing Page Widgets
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
                  formKey: _loginFormKey,
                  emailController: _emailControllerLogin,
                  passwordController: _passwordControllerLogin,
                  onSignInPressed: _login,
                  onForgotPasswordPressed: _toForgotPasswordPage,
                  onGoogleSignInPressed: _toSignInWithGoogle,
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
                builder: (context) => SignUpPage(
                  formKey: _signUpFormKey,
                  fullNameController: _signUpNameController,
                  emailController: _signUpEmailController,
                  passwordController: _signUpPasswordController,
                  onSignUpPressed: _register,
                  onGoogleSignUpPressed: _toSignUpWithGoogle,
                ),
              ),
            ),
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

/* --------------------------- Login Page Members --------------------------- */
// Login Page Members
  final _loginFormKey = GlobalKey<FormState>();
  final _emailControllerLogin = TextEditingController();
  final _passwordControllerLogin = TextEditingController();

  void _login() async {
    final form = _loginFormKey.currentState!;

    if (form.validate()) {
      final String email = _emailControllerLogin.text.trim();
      final String password = _passwordControllerLogin.text.trim();

      await _signIn(email, password);
    }
  }

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

      final user = AuthService.firebase().currentUser;

      if (user != null && !user.isEmailVerified) {
        // Navigate to verify email page
        _toVerifyEmailPage();
      } else {
        // Navigate to home page
        _toHomePage();
      }
    } on UserNotFoundAuthException {
      _errorSnack('User not found');
    } on WrongPasswordAuthException {
      _errorSnack('Invalid Login Credentials');
    } on GenericAuthException {
      _errorSnack('Authentication failed');
    }
  }

  Future _toSignInWithGoogle() async {
    try {
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

      // final provider = Provider.of<GoogleAuthProvide>(context, listen: false);
      // await provider.signInWithGoogle();

      await GoogleService.google().signInWithGoogle();
      final user = GoogleService.google().currentUser;

      if (user != null) {
        _toHomePage();
      }
    } on UserNotFoundAuthException {
      _errorSnack('User not found');
    } on GenericAuthException {
      _errorSnack('Authentication failed');
    }
  }

  // -- /* ------------------Navigations---------------- */ -- //
  void _toForgotPasswordPage() {
    _clearLoginFields();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordPage(
          emailController: _emailControllerForgot,
          formKey: _forgotFormKey,
          onSendResetLinkPressed: _reset,
        ),
      ),
    );
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

  void _errorSnack(String message) {
    Navigator.pop(context);
    Utils.showSnackBar(context, message);
  }
  // -- /* -------------------------------------------- */ -- //

  void _clearLoginFields() {
    _emailControllerLogin.clear();
    _passwordControllerLogin.clear();
  }
/* -------------------------------------------------------------------------- */

/* -------------------------- Sign Up Page Members ------------------------- */
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();

  void _register() async {
    final form = _signUpFormKey.currentState!;

    if (form.validate()) {
      //final String fullName = _signUpNameController.text.trim();
      final String email = _signUpEmailController.text.trim();
      final String password = _signUpPasswordController.text.trim();

      await _signUp(email, password);
    }
  }

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
      _errorSnack('Password is too weak');
    } on EmailAlreadyInUseAuthException {
      _errorSnack('Email already in use');
    } on InvalidEmailAuthException {
      _errorSnack('Password is too weak');
    } on GenericAuthException {
      _errorSnack('Sign up failed');
    }
  }

  Future _toSignUpWithGoogle() async {
    try {
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

      // final provider = Provider.of<GoogleAuthProvide>(context, listen: false);
      // await provider.signInWithGoogle();

      await GoogleService.google().signInWithGoogle();
      final user = GoogleService.google().currentUser;

      if (user != null) {
        _toHomePage();
      }
    } on UserNotFoundAuthException {
      _errorSnack('User not found');
    } on GenericAuthException {
      _errorSnack('Authentication failed');
    }
  }

  // -- /* ------------------Navigations---------------- */ -- //
  void _toVerifyEmailPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const VerifyEmailPage(),
      ),
      ((route) => route.isFirst),
    );
  }

  // -- /* -------------------------------------------- */ -- //

  void _clearSignUpFields() {
    _signUpNameController.clear();
    _signUpEmailController.clear();
    _signUpPasswordController.clear();
  }

/* -------------------------------------------------------------------------- */

/* -------------------------- Forgot Password Page -------------------------- */

  final _emailControllerForgot = TextEditingController();
  final _forgotFormKey = GlobalKey<FormState>();

  void _reset() async {
    final form = _forgotFormKey.currentState!;

    if (form.validate()) {
      final String email = _emailControllerForgot.text.trim();

      _sendPasswordResetLink(email);
    }
  }

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
      _emailControllerForgot.clear();
      _errorSnack('Reset link sent to $email');
      _toLandingPage();
    } on InvalidEmailAuthException {
      _errorSnack('Password is too weak');
    } on UserNotFoundAuthException {
      _errorSnack('User not found');
    } on GenericAuthException {
      _errorSnack('Failed to send reset link');
    }
  }

  // -- /* ------------------Navigations---------------- */ -- //
  void _toLandingPage() {
    _clearForgotFields();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingPage(),
      ),
      ((route) => route.isFirst),
    );
  }
  // -- /* -------------------------------------------- */ -- //

  void _clearForgotFields() {
    _emailControllerForgot.clear();
  }

/* -------------------------------------------------------------------------- */
}

/* -------------------------------------------------------------------------- */
//!SECTION: Landing Page

//SECTION: Login Page
/* -------------------------------------------------------------------------- */
class SignInPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function onSignInPressed;
  final Function onForgotPasswordPressed;
  final Function onGoogleSignInPressed;

  const SignInPage(
      {super.key,
      required this.formKey,
      required this.emailController,
      required this.passwordController,
      required this.onSignInPressed,
      required this.onForgotPasswordPressed,
      required this.onGoogleSignInPressed});

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
                        onPressed: () => onForgotPasswordPressed(),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    FilledButton(
                      onPressed: () => onSignInPressed(),
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
                      onPressed: () => onGoogleSignInPressed(),
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
}
/* -------------------------------------------------------------------------- */
//!SECTION: Login Page

// SECTION: Register Page
/* -------------------------------------------------------------------------- */
class SignUpPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function onSignUpPressed;
  final Function onGoogleSignUpPressed;

  const SignUpPage({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.onSignUpPressed,
    required this.onGoogleSignUpPressed,
  });

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
            onPressed: () => onSignUpPressed(),
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
}

/* -------------------------------------------------------------------------- */
// !SECTION: Register Page

// SECTION: Forgot Password Page
/* -------------------------------------------------------------------------- */
class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController? emailController;
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
                emailController!.clear();
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

// SECTION: Verify Email Page
/* -------------------------------------------------------------------------- */
class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Check Your Mail'),
            centerTitle: true,
            titleTextStyle: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(75.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'We,ve sent a verification email to verify your email address.'
                  'You might wanna check your spam if you cant find it.',
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
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const CountdownTimer(),
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 27),
                        OutlinedButton(
                          onPressed: () {
                            AuthService.firebase().logOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LandingPage(),
                              ),
                              ((route) => route.isFirst),
                            );
                          },
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
                            'Cancel',
                          ),
                        ),
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
}

// Component: Counter Timer Text Widget
class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  int _secondsRemaining = 59;
  late Timer _timer1;
  late Timer _timer2;
  bool _isTimerActive = true;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    startCountdown();
    if (!_isEmailVerified) {
      _timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
        _checkEmailVerification();
      });
    }
  }

  @override
  void dispose() {
    _timer1.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('mm : ss').format(
      DateTime(0, 0, 0, 0, 0, _secondsRemaining),
    );
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          height: 180,
          alignment: Alignment.center,
          child: Text(
            formattedTime,
            style: textTheme.titleLarge!.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        FilledButton(
          onPressed: _isTimerActive
              ? null
              : () {
                  setState(() {
                    _secondsRemaining = 59;
                    _isTimerActive = true;
                  });
                  startCountdown();
                  sendEmailVerification();
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
            'Resend Verification Email',
          ),
        ),
      ],
    );
  }

  void startCountdown() {
    _timer1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer1.cancel();
          _isTimerActive = false;
        }
      });
    });
  }

  Future _checkEmailVerification() async {
    //await AuthService.firebase().currentUser!.reload();
    //await FirebaseAuth.instance.currentUser!.reload();
    _isEmailVerified = AuthService.firebase().currentUser!.isEmailVerified;

    if (_isEmailVerified) {
      _toHomePage();
      _timer1.cancel();
      _timer2.cancel();
    }
  }

  Future sendEmailVerification() async {
    try {
      final user = AuthService.firebase().currentUser;

      if (user != null && !user.isEmailVerified) {
        await AuthService.firebase().sendEmailVerification();
      }
    } on GenericAuthException {
      _errorSnack('Failed to send verification email');
    }
  }

  void _errorSnack(String message) {
    Utils.showSnackBar(context, message);
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
}
/* -------------------------------------------------------------------------- */
// !SECTION: Verify Email Page

// SECTION: AUTH PAGE Components
/* -------------------------------------------------------------------------- */

// Component: Email Text Form Field
class EmailTextFormField extends StatefulWidget {
  const EmailTextFormField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController? controller;

  @override
  State<EmailTextFormField> createState() => _EmailTextFormFieldState();
}

class _EmailTextFormFieldState extends State<EmailTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        labelText: 'Email',
        hintText: 'Enter your email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      autofillHints: const [AutofillHints.email],
      validator: (email) => email != null && !EmailValidator.validate(email)
          ? 'Please enter a valid email address'
          : null,
    );
  }
}

// Component: Password Text Form Field
class PassWordTextFormField extends StatefulWidget {
  const PassWordTextFormField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController? controller;

  @override
  State<PassWordTextFormField> createState() => _PassWordTextFormFieldState();
}

class _PassWordTextFormFieldState extends State<PassWordTextFormField> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      textInputAction: TextInputAction.done,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.remove_red_eye_outlined,
          ),
          onPressed: () => _togglePasswordVisibility(),
        ),
        labelText: 'Password',
        hintText: 'Enter your password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: (password) {
        if (password == null || password.isEmpty) {
          return 'Please enter a password';
        }
        if (password.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }
}

// Component: Normal Text Form Field
class NormalTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final String errorText;
  final Icon? prefixIcon;
  final bool needsValidation;
  const NormalTextFormField({
    Key? key,
    required this.controller,
    required this.needsValidation,
    required this.labelText,
    required this.hintText,
    required this.errorText,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<NormalTextFormField> createState() => _NormalTextFormFieldState();
}

class _NormalTextFormFieldState extends State<NormalTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: widget.needsValidation
          ? (value) {
              if (value == null || value.isEmpty) {
                return widget.errorText;
              }
              return null;
            }
          : null,
    );
  }
}

// Utilities
class Utils {
  static void showSnackBar(BuildContext context, String message,[Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
// !SECTION: Components

// SECTION: AUTHENTICATION
// Description: Authentication methods for the app
// Signing in with user email and password

class MyFireBase {
  MyFireBase._internal();
  static final MyFireBase instance = MyFireBase._internal();
  factory MyFireBase() => instance;

  static String verifyError = 'Something went wrong. Please try again later.';
}
