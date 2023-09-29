import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:smarsh/services/hive/service/hive_service.dart';

import 'views/auth-views/landing_page.dart';
import 'services/auth/email_n_password/auth_service.dart';
import 'views/homepage-views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait mode with the device upright
    DeviceOrientation.portraitDown, // Portrait mode with the device upside down
  ]);

  await AppService.firebase().initialize();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  print(appDocumentDir.path);
  await HiveService.registerAdapters();
  await HiveService.initFlutter(appDocumentDir.path);

  runApp(
    MaterialApp(
      title: 'Smarsh',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SmarshApp(),
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
        print('Stream is listening');

        if (snapshot.hasData) {
          // if (snapshot.data!.isEmailVerified == false) {
          //   AuthService.firebase().sendEmailVerification();
          //   return const VerifyEmailPage();
          // }

          print(snapshot.data!.email);
          return const HomePage();
        } else {
          return const LandingPage();
        }
      },
    );
  }
}
