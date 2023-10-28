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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIdOiVy9c6YqwCE0VLd03ocfAF6UFDHN0',
    appId: '1:850116129107:android:45d88b04bbea5bdd2131a6',
    messagingSenderId: '850116129107',
    projectId: 'cineverse-70e0b',
    storageBucket: 'cineverse-70e0b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCclRyT7ppNXMilr8rEMmR_Vuegr-CnCAI',
    appId: '1:850116129107:ios:147ce0b24747a5212131a6',
    messagingSenderId: '850116129107',
    projectId: 'cineverse-70e0b',
    storageBucket: 'cineverse-70e0b.appspot.com',
    iosBundleId: 'com.example.cineverse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCclRyT7ppNXMilr8rEMmR_Vuegr-CnCAI',
    appId: '1:850116129107:ios:42db17e008a34a232131a6',
    messagingSenderId: '850116129107',
    projectId: 'cineverse-70e0b',
    storageBucket: 'cineverse-70e0b.appspot.com',
    iosBundleId: 'com.example.cineverse.RunnerTests',
  );
}