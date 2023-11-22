import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'app.dart';
import 'features/2-Authentification/2-authentification/services/auth_service.dart';
import 'services/hive/models/show_home_model/show_home.dart';
import 'services/hive/service/hive_constants.dart';
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

  final bool getShowHome = HiveBoxes.getShowOnboardBox.isEmpty;
  getShowHome
      ? await HiveShowHome().addShowHome(ShowOnboard(showOnboard: true))
      : null;

  runApp(const SmarshApp());
}