import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../2-Authentification/2-authentification/views/login_page.dart';
import '../../2-Authentification/2-authentification/views/sign_up_page.dart';

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

/* -------------------------------------------------------------------------- */
//!SECTION: Landing Page

