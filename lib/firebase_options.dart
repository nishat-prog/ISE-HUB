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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCS6QAQE-97DhnRLK3903HYijUjQXwD-Ek',
    appId: '1:890140833733:web:3fb53be47023f52193bdac',
    messagingSenderId: '890140833733',
    projectId: 'ise-hub-mp1',
    authDomain: 'ise-hub-mp1.firebaseapp.com',
    storageBucket: 'ise-hub-mp1.appspot.com',
    measurementId: 'G-V2S0XGXZSE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyArb7Y7_nsUGi0dH1bmGJ-HgCkyoIJxee4',
    appId: '1:890140833733:android:9a71331772e3083f93bdac',
    messagingSenderId: '890140833733',
    projectId: 'ise-hub-mp1',
    storageBucket: 'ise-hub-mp1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAoYpEbHVK1Sem3pzlRwtjgPM-kwyNPe-I',
    appId: '1:890140833733:ios:f5b9ddd28850e5ef93bdac',
    messagingSenderId: '890140833733',
    projectId: 'ise-hub-mp1',
    storageBucket: 'ise-hub-mp1.appspot.com',
    iosBundleId: 'com.example.iseHubMp1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAoYpEbHVK1Sem3pzlRwtjgPM-kwyNPe-I',
    appId: '1:890140833733:ios:d32fd2e3149b39ac93bdac',
    messagingSenderId: '890140833733',
    projectId: 'ise-hub-mp1',
    storageBucket: 'ise-hub-mp1.appspot.com',
    iosBundleId: 'com.example.iseHubMp1.RunnerTests',
  );
}
