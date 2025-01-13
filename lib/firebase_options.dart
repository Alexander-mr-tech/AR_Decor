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
    apiKey: 'AIzaSyAm7_cuqsuDMiCECuxv_J8ohR8YGXKoSkA',
    appId: '1:1078175140637:web:d65450e8986bb4d8f56ff4',
    messagingSenderId: '1078175140637',
    projectId: 'ar-decor-6851a',
    authDomain: 'ar-decor-6851a.firebaseapp.com',
    storageBucket: 'ar-decor-6851a.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1X3-4TyHBb0IrBdEbiHhfFwKzOIk95-4',
    appId: '1:1078175140637:android:8d06c4151a07c8dbf56ff4',
    messagingSenderId: '1078175140637',
    projectId: 'ar-decor-6851a',
    storageBucket: 'ar-decor-6851a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLQGjkPvrq05UWaw1HpHgylSosc7ELBDs',
    appId: '1:1078175140637:ios:a2c1ca9f6b47c2bdf56ff4',
    messagingSenderId: '1078175140637',
    projectId: 'ar-decor-6851a',
    storageBucket: 'ar-decor-6851a.firebasestorage.app',
    iosBundleId: 'com.example.ardecor.arDecor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDLQGjkPvrq05UWaw1HpHgylSosc7ELBDs',
    appId: '1:1078175140637:ios:a2c1ca9f6b47c2bdf56ff4',
    messagingSenderId: '1078175140637',
    projectId: 'ar-decor-6851a',
    storageBucket: 'ar-decor-6851a.firebasestorage.app',
    iosBundleId: 'com.example.ardecor.arDecor',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAm7_cuqsuDMiCECuxv_J8ohR8YGXKoSkA',
    appId: '1:1078175140637:web:d8861216439bfd6bf56ff4',
    messagingSenderId: '1078175140637',
    projectId: 'ar-decor-6851a',
    authDomain: 'ar-decor-6851a.firebaseapp.com',
    storageBucket: 'ar-decor-6851a.firebasestorage.app',
  );
}
