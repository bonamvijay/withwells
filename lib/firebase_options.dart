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
    apiKey: 'AIzaSyCR48HqsG9b-ctuAezoGRKf2H-6puIvhEU',
    appId: '1:123420150589:web:2619be4e9077e8dc135354',
    messagingSenderId: '123420150589',
    projectId: 'devwithwells',
    authDomain: 'devwithwells.firebaseapp.com',
    databaseURL: 'https://devwithwells-default-rtdb.firebaseio.com',
    storageBucket: 'devwithwells.appspot.com',
    measurementId: 'G-ZLLX1HC81N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9xpiRjSrCQcP-X-1DpSRdVgv1KIjzvLY',
    appId: '1:123420150589:android:334c842e6f7fa0c7135354',
    messagingSenderId: '123420150589',
    projectId: 'devwithwells',
    databaseURL: 'https://devwithwells-default-rtdb.firebaseio.com',
    storageBucket: 'devwithwells.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7zVIU_UEWNFNr1rxohLFVEMjOjfN3yj0',
    appId: '1:123420150589:ios:72d55207becea6f9135354',
    messagingSenderId: '123420150589',
    projectId: 'devwithwells',
    databaseURL: 'https://devwithwells-default-rtdb.firebaseio.com',
    storageBucket: 'devwithwells.appspot.com',
    iosClientId: '123420150589-c3hp6jmvlphlf7ses6hbcvn2bo5of1la.apps.googleusercontent.com',
    iosBundleId: 'com.example.withwells',
  );
}
