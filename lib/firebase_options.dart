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
    apiKey: 'AIzaSyCJxs0mV68ZQumX5y7lQPDc7VC4Eiv7jeY',
    appId: '1:212126226191:web:bb608e283e60caf372507a',
    messagingSenderId: '212126226191',
    projectId: 'task-app-6109f',
    authDomain: 'task-app-6109f.firebaseapp.com',
    storageBucket: 'task-app-6109f.appspot.com',
    measurementId: 'G-Y1N0R4HFV9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuRgHg5tM73tD7_neSjRBHeH5BUVXUvp8',
    appId: '1:212126226191:android:065587fb666ba44a72507a',
    messagingSenderId: '212126226191',
    projectId: 'task-app-6109f',
    storageBucket: 'task-app-6109f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCiOSQQWWTo9iE6yD4PcgTOltizGGlqfVo',
    appId: '1:212126226191:ios:643e7270022d9db472507a',
    messagingSenderId: '212126226191',
    projectId: 'task-app-6109f',
    storageBucket: 'task-app-6109f.appspot.com',
    iosBundleId: 'com.example.taskCollab',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCiOSQQWWTo9iE6yD4PcgTOltizGGlqfVo',
    appId: '1:212126226191:ios:8f0bfa28da436a7872507a',
    messagingSenderId: '212126226191',
    projectId: 'task-app-6109f',
    storageBucket: 'task-app-6109f.appspot.com',
    iosBundleId: 'com.example.taskCollab.RunnerTests',
  );
}
