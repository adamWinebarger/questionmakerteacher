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
    apiKey: 'AIzaSyCqAcTjiSkNJ5wXHQ_P4XzKJCBwSEB6ZIA',
    appId: '1:902854820307:web:2ce3ca3b9e4b62529bef26',
    messagingSenderId: '902854820307',
    projectId: 'schoolquestiontester',
    authDomain: 'schoolquestiontester.firebaseapp.com',
    storageBucket: 'schoolquestiontester.appspot.com',
    measurementId: 'G-DLHWPV8MFL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcB8UvlSK7jL59HjAAFQSilyjjbxE26HY',
    appId: '1:902854820307:android:9af3b1d1663ccad49bef26',
    messagingSenderId: '902854820307',
    projectId: 'schoolquestiontester',
    storageBucket: 'schoolquestiontester.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArqTig_FfR2-8xHB1HcNwlICecWv_GiU4',
    appId: '1:902854820307:ios:b1a05600a5c21d809bef26',
    messagingSenderId: '902854820307',
    projectId: 'schoolquestiontester',
    storageBucket: 'schoolquestiontester.appspot.com',
    iosBundleId: 'com.adamwinebarger.questionmakerteacher',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyArqTig_FfR2-8xHB1HcNwlICecWv_GiU4',
    appId: '1:902854820307:ios:52aa240e469e39289bef26',
    messagingSenderId: '902854820307',
    projectId: 'schoolquestiontester',
    storageBucket: 'schoolquestiontester.appspot.com',
    iosBundleId: 'com.example.questionmakerteacher.RunnerTests',
  );
}
