import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'features/1-splash-onboard-landing/views/landing_page.dart';
import 'features/1-splash-onboard-landing/views/onboard_page.dart';
import 'features/2-Authentification/2-authentification/provider/auth_provider.dart';
import 'features/2-Authentification/2-authentification/views/verify_email_page.dart';
import 'features/2-Authentification/model/auth_user_entity.dart';
import 'features/4-home-page/view/home_page.dart';
import 'global/providers/smarsh_providers.dart';
import 'services/hive/models/show_home_model/show_home.dart';
import 'services/hive/service/hive_constants.dart';

class SmarshApp extends StatelessWidget {
  const SmarshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProviders>(
          create: (context) => AppProviders(),
        ),
      ],
      child: MaterialApp(
        title: 'Smarsh',
        theme: ThemeData(
          // brightness: Brightness.dark,
          fontFamily: 'Montserrat',
          colorSchemeSeed: Colors.green,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: ValueListenableBuilder(
          valueListenable: HiveBoxes.getShowOnboardBox.listenable(),
          builder: (BuildContext context, Box<ShowOnboard> box, _) {
            // if (true) {
            final ShowOnboard showOnboard = box.values.first;

            if (showOnboard.showOnboard) {
              return const OnBoardPage();
            } else {
              return StreamBuilder(
                stream: AuthProvider().currentUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final user = snapshot.data;

                    if (user != AuthUser.empty) {
                      if (user!.isEmailVerified) {
                        return const HomePage();
                      } else {
                        return const VerifyEmailPage();
                      }
                    } else {
                      return const LandingPage();
                    }
                  } else {
                    return const Scaffold(
                      body: Center(
                        child: SizedBox(
                          height: 75,
                          width: 75,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                },
              );
            }
            // }
          },
        ),
      ),
    );
  }
}
