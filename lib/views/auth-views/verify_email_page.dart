import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'landing_page.dart';
import '../../constants/hive_constants.dart';
import '../../services/auth/email_n_password/auth_exceptions.dart';
import '../../services/auth/email_n_password/auth_service.dart';
import '../../services/hive/models/user_model/user_model.dart';
import '../homepage-views/home_page.dart';
import 'auth_widgets.dart';

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
                child: const CountdownTimer(),
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
        const SizedBox(height: 27),
        OutlinedButton(
          onPressed: () async {
            _cleanUp();
            await AuthService.firebase().logOut();
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
    _isEmailVerified = AppService.firebase().currentUser!.isEmailVerified;

    if (_isEmailVerified) {
      HiveUser? userHive = GetMeFromHive.getHiveUser;

      userHive!.email = AppService.firebase().currentUser!.email;
      userHive.name = 'Stranger';
      userHive.url = 'https://ianshaloom.github.io/assets/img/perfil.png';
      userHive.isGoogleSignIn = false;
      userHive.isEmailVerified = _isEmailVerified;

      await userHive.save();

      _toHomePage();
      _timer1.cancel();
      _timer2.cancel();
    }
  }

  Future sendEmailVerification() async {
    try {
      final user = AppService.firebase().currentUser!;

      if (!user.isEmailVerified) {
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

  void _cleanUp() {
    _timer1.cancel();
    _timer2.cancel();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingPage(),
      ),
      ((route) => route.isFirst),
    );
  }
}
/* -------------------------------------------------------------------------- */
// !SECTION: Verify Email Page
