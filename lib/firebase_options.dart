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
    apiKey: 'AIzaSyBbeU5kSR7vSz5bTmUhnWKmvEtheR-yLv0',
    appId: '1:1052417728796:web:20e2bdb1f44c7d28641ad9',
    messagingSenderId: '1052417728796',
    projectId: 'devwithwells-9c948',
    authDomain: 'devwithwells-9c948.firebaseapp.com',
    storageBucket: 'devwithwells-9c948.appspot.com',
    measurementId: 'G-9JSX2C144F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCc45bo1DYPzyxtUbjsbW89HLzqnAOzd-k',
    appId: '1:1052417728796:android:06485d55410bc581641ad9',
    messagingSenderId: '1052417728796',
    projectId: 'devwithwells-9c948',
    storageBucket: 'devwithwells-9c948.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBll00SPUIALGrdxI0Um-db-emGC4L3pFk',
    appId: '1:1052417728796:ios:f91a59d5e61852e7641ad9',
    messagingSenderId: '1052417728796',
    projectId: 'devwithwells-9c948',
    storageBucket: 'devwithwells-9c948.appspot.com',
    iosClientId: '1052417728796-i4lkmcphkrbtcpf0pojuh0dov0aa7d5v.apps.googleusercontent.com',
    iosBundleId: 'com.example.withwells',
  );
}
