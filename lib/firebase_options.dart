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
    apiKey: 'AIzaSyA6pr5ob2w8qCEpadRXEj_v9M1fZxSieoE',
    appId: '1:226543086616:web:05e70cb08f00d1d892a76d',
    messagingSenderId: '226543086616',
    projectId: 'sovarvo-40099',
    authDomain: 'sovarvo-40099.firebaseapp.com',
    databaseURL: 'https://sovarvo-40099-default-rtdb.firebaseio.com',
    storageBucket: 'sovarvo-40099.appspot.com',
    measurementId: 'G-K3W6CNTM7D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5NVyctrHcEQamiEjnDqV8YKbRsa7JalY',
    appId: '1:226543086616:android:52eabf2e5b3e080992a76d',
    messagingSenderId: '226543086616',
    projectId: 'sovarvo-40099',
    authDomain: 'sovarvo-40099.firebaseapp.com',
    databaseURL: 'https://sovarvo-40099-default-rtdb.firebaseio.com',
    storageBucket: 'sovarvo-40099.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5PqCCJpGaNHWF6x5IQcxpV-T0jbb-FGQ',
    appId: '1:226543086616:ios:65d9e4b531eca91b92a76d',
    messagingSenderId: '226543086616',
    projectId: 'sovarvo-40099',
    authDomain: 'sovarvo-40099.firebaseapp.com',
    databaseURL: 'https://sovarvo-40099-default-rtdb.firebaseio.com',
    storageBucket: 'sovarvo-40099.appspot.com',
    iosBundleId: 'com.example.webProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5PqCCJpGaNHWF6x5IQcxpV-T0jbb-FGQ',
    appId: '1:226543086616:ios:353d7cd079b241db92a76d',
    messagingSenderId: '226543086616',
    projectId: 'sovarvo-40099',
    authDomain: 'sovarvo-40099.firebaseapp.com',
    databaseURL: 'https://sovarvo-40099-default-rtdb.firebaseio.com',
    storageBucket: 'sovarvo-40099.appspot.com',
    iosBundleId: 'com.example.sovarvo.RunnerTests',
  );
}
