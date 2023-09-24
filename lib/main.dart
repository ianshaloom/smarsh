import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:smarsh/firebase_options.dart';

import 'app.dart';
import 'services/cloud/cloud_product.dart';
import 'services/cloud/firebase_cloud_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait mode with the device upright
    DeviceOrientation.portraitDown, // Portrait mode with the device upside down
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SmarshApp());
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
