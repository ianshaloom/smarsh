import 'package:flutter/material.dart';
import 'package:smarsh/services/auth/auth_service.dart';

import 'auth_pages.dart';
import 'views/homepage-views/home_page.dart';

class SmarshApp extends StatelessWidget {
  const SmarshApp({super.key});

  // return either home or authenticate widget

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smarsh',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: AppService.firebase().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            final user = AuthService.firebase().currentUser;
            print('user: $user');

            if (!snapshot.data!.isEmailVerified) {
              print(user!.email);
              return const VerifyEmailPage();
            } else {
              return const HomePage();
            }
          } else {
            print('I have been signed out');
            return const LandingPage();
          }

          // if (snapshot.connectionState == ConnectionState.done) {

          // } else {

          // }

          // switch (snapshot.connectionState) {
          //   case ConnectionState.done:
          //     final user = AuthService.firebase().currentUser;
          //     print('user: $user');

          //     if (user == null) {
          //       return const LandingPage();
          //     } else if (!user.isEmailVerified) {
          //       return const VerifyEmailPage();
          //     } else {
          //       return const HomePage();
          //     }
          //   default:
          //     return Scaffold(
          //       appBar: AppBar(
          //         backgroundColor: Theme.of(context).colorScheme.surface,
          //       ),
          //       body: const Center(
          //         child: CircularProgressIndicator(),
          //       ),
          //     );
          // }
        },
      ),
    );
  }
}
