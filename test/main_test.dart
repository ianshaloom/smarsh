// import 'package:flutter_test/flutter_test.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:smarsh/services/auth/email_n_password/auth_service.dart';
// import 'package:smarsh/services/hive/models/user_model/user_model.dart';
// import 'package:smarsh/services/hive/service/hive_service.dart';

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   group('App initialization', () {
//     test('Firebase is initialized', () async {
//       await AppService.firebase().initialize();
//       // Add your assertion here
//     });

//     test('Hive is initialized', () async {
//       final appDocumentDir =
//           await path_provider.getApplicationDocumentsDirectory();
//       await HiveService.registerAdapters();
//       await HiveService.initFlutter(appDocumentDir.path);
//       // Add your assertion here
//     });

//     test('Hive user is added', () async {
//       final appDocumentDir =
//           await path_provider.getApplicationDocumentsDirectory();
//       await HiveService.registerAdapters();
//       await HiveService.initFlutter(appDocumentDir.path);
//       HiveUser hiveUser = HiveUser(
//         url: 'https://ianshaloom.github.io/assets/img/perfil.png',
//         name: 'Stranger',
//         email: 'info@smarsh.com',
//         isEmailVerified: false,
//         isGoogleSignIn: false,
//       );
//       await HiveUserService().addUser(hiveUser);
//       // Add your assertion here
//     });
//   });
// }
