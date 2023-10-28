import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

import 'features/2-authentification/services/auth_user.dart';
import 'global/providers/smarsh_providers.dart';
import 'features/1-splash-onboard-landing/views/landing_page.dart';
import 'features/2-authentification/services/auth_service.dart';
import 'features/2-authentification/views/verify_email_page.dart';
import 'features/4-home-page/view/home_page.dart';
import 'services/hive/service/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait mode with the device upright
    DeviceOrientation.portraitDown, // Portrait mode with the device upside down
  ]);

  await AppService.firebase().initialize();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await HiveService.registerAdapters();
  await HiveService.initFlutter(appDocumentDir.path);

  runApp(
    MultiProvider(
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
        home: const SmarshApp(),
      ),
    ),
  );
}

class SmarshApp extends StatelessWidget {
  const SmarshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AppService.firebase().authStateChanges,
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
}
// 0