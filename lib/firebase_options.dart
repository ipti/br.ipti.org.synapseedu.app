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
    apiKey: 'AIzaSyClPT9D0cMMfIK3WQdUq-KXyP4TkAkulQE',
    appId: '1:437443678895:web:d3f81ff87a7292dfb1ba5a',
    messagingSenderId: '437443678895',
    projectId: 'ipti-synapse-edu',
    authDomain: 'ipti-synapse-edu.firebaseapp.com',
    storageBucket: 'ipti-synapse-edu.appspot.com',
    measurementId: 'G-HRQ0PKG8FL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBS70qzUfeYO6aLsn9rwVyYXiqCGQejS4M',
    appId: '1:437443678895:android:d591ed65a23f7b7ab1ba5a',
    messagingSenderId: '437443678895',
    projectId: 'ipti-synapse-edu',
    storageBucket: 'ipti-synapse-edu.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTFUrqGDvKNUcy-PQ6xy9Agz4XWdGFRwI',
    appId: '1:437443678895:ios:dc552fc8e06ea52ab1ba5a',
    messagingSenderId: '437443678895',
    projectId: 'ipti-synapse-edu',
    storageBucket: 'ipti-synapse-edu.appspot.com',
    iosBundleId: 'br.com.elesson',
  );
}
