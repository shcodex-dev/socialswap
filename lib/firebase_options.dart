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
    apiKey: 'AIzaSyDaJ22Hxk7fLVWwwjAld1hldq0bXS1WrPM',
    appId: '1:877804633592:web:0d44548d8bceebbcfd2a0d',
    messagingSenderId: '877804633592',
    projectId: 'socail-swap',
    authDomain: 'socail-swap.firebaseapp.com',
    databaseURL:
        "https://socail-swap-default-rtdb.asia-southeast1.firebasedatabase.app",
    storageBucket: 'socail-swap.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQmER2rr0I-eD0tKaUGXUMLpxT4ppJZSM',
    appId: '1:877804633592:android:f061ae3c4b17d59efd2a0d',
    messagingSenderId: '877804633592',
    projectId: 'socail-swap',
    databaseURL:
        "https://socail-swap-default-rtdb.asia-southeast1.firebasedatabase.app",
    storageBucket: 'socail-swap.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASYeenPAGVcqRJIIGYviVWe74ftx7dCRw',
    appId: '1:877804633592:ios:bbd2c8465315c11cfd2a0d',
    messagingSenderId: '877804633592',
    projectId: 'socail-swap',
    storageBucket: 'socail-swap.appspot.com',
    iosBundleId: 'com.example.socialswap',
    databaseURL:
        "https://socail-swap-default-rtdb.asia-southeast1.firebasedatabase.app",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyASYeenPAGVcqRJIIGYviVWe74ftx7dCRw',
    appId: '1:877804633592:ios:9357df974105dffffd2a0d',
    messagingSenderId: '877804633592',
    projectId: 'socail-swap',
    storageBucket: 'socail-swap.appspot.com',
    iosBundleId: 'com.example.socialswap.RunnerTests',
    databaseURL:
        "https://socail-swap-default-rtdb.asia-southeast1.firebasedatabase.app",
  );
}
