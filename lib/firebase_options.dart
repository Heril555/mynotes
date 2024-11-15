// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDjdQl8vFXP-h8yhenlqwEoJW2AcOfsH3E',
    appId: '1:852029103276:web:101ef61fbde1d08e7d5309',
    messagingSenderId: '852029103276',
    projectId: 'mynotes-16019',
    authDomain: 'mynotes-16019.firebaseapp.com',
    storageBucket: 'mynotes-16019.firebasestorage.app',
    measurementId: 'G-B0H7LS5Q6P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2UN55e1UF0Uk7SAgu3VWBJRu892WuWPw',
    appId: '1:852029103276:android:63003645944ad4d37d5309',
    messagingSenderId: '852029103276',
    projectId: 'mynotes-16019',
    storageBucket: 'mynotes-16019.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAU4G7jDOQ-jjEEkRHQCJ-5_NbZ8RjUwxE',
    appId: '1:852029103276:ios:ba7d7d03d2d696b17d5309',
    messagingSenderId: '852029103276',
    projectId: 'mynotes-16019',
    storageBucket: 'mynotes-16019.firebasestorage.app',
    iosBundleId: 'com.heril.mynotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAU4G7jDOQ-jjEEkRHQCJ-5_NbZ8RjUwxE',
    appId: '1:852029103276:ios:ba7d7d03d2d696b17d5309',
    messagingSenderId: '852029103276',
    projectId: 'mynotes-16019',
    storageBucket: 'mynotes-16019.firebasestorage.app',
    iosBundleId: 'com.heril.mynotes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDjdQl8vFXP-h8yhenlqwEoJW2AcOfsH3E',
    appId: '1:852029103276:web:77138d69f92fa1787d5309',
    messagingSenderId: '852029103276',
    projectId: 'mynotes-16019',
    authDomain: 'mynotes-16019.firebaseapp.com',
    storageBucket: 'mynotes-16019.firebasestorage.app',
    measurementId: 'G-CV6X0B8PM9',
  );
}