import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smarsh/constants/hive_constants.dart';
import 'package:smarsh/services/auth/email_n_password/auth_service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


import 'auth_pages.dart';
import 'services/cloud/cloud_product.dart';
import 'services/cloud/firebase_cloud_storage.dart';
import 'services/hive/models/local_product/local_product_model.dart';
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
  Hive.init(appDocumentDir.path);  
  await Hive.openBox<LocalProduct>(localProduct);

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


class Shared {
  Shared._();
  static final Shared instance = Shared._();
  factory Shared() => instance;

  static String generateProductCode(int length) {
    const String charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    String code = '';

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(charset.length);
      code += charset[randomIndex];
    }

    return code;
  }
}

class Data {
  Data._();
  static final Data instance = Data._();
  factory Data() => instance;

  static List<CloudProduct> get stock {
    // Assuming you have a reference to your stream
    Stream<Iterable<CloudProduct>> productStream =
        FirebaseCloudStorage().allProducts();

// Create a list to store the CloudProduct objects
    List<CloudProduct> productList = [];

// Listen to the stream and collect the items into the list
    productStream.listen((Iterable<CloudProduct> products) {
      productList = products.toList();
    });

    print(productList.length);

    return productList;
  }
}
