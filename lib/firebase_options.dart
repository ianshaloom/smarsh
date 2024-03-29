// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBOS6ub2A0H0MLY70uy4mZZaHsMCzq6tEg',
    appId: '1:105653625919:web:16ee7de753e03dddbd048a',
    messagingSenderId: '105653625919',
    projectId: 'smarsh-1f6a8',
    authDomain: 'smarsh-1f6a8.firebaseapp.com',
    storageBucket: 'smarsh-1f6a8.appspot.com',
    measurementId: 'G-0P7VJ3WG1R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDeDljWQ9DExG8MFWV_8SgjHxYr91v2V64',
    appId: '1:105653625919:android:ac44418bd4182e92bd048a',
    messagingSenderId: '105653625919',
    projectId: 'smarsh-1f6a8',
    storageBucket: 'smarsh-1f6a8.appspot.com',
  );
}
