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
    apiKey: 'AIzaSyD2Rui9s4zYXRfZJgBTpxupTpBOehI61TU',
    appId: '1:1074945236940:web:2da283329661c69d604769',
    messagingSenderId: '1074945236940',
    projectId: 'oneapp-af948',
    authDomain: 'oneapp-af948.firebaseapp.com',
    storageBucket: 'oneapp-af948.appspot.com',
    measurementId: 'G-4VJ5JVECFL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB61sEJpziCAgNjYkycjfGCCAzI1yYg2l8',
    appId: '1:1074945236940:android:692c1366ed9e030f604769',
    messagingSenderId: '1074945236940',
    projectId: 'oneapp-af948',
    storageBucket: 'oneapp-af948.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmFkffOWyW73NQ9qln_kUTiM3Y0bPb6BY',
    appId: '1:1074945236940:ios:558925aee4b80156604769',
    messagingSenderId: '1074945236940',
    projectId: 'oneapp-af948',
    storageBucket: 'oneapp-af948.appspot.com',
    androidClientId: '1074945236940-5590q14ssqcpvpna5f1pdao4374v6909.apps.googleusercontent.com',
    iosClientId: '1074945236940-137ocdo8qpjd2gkiftov58ecjstjoeod.apps.googleusercontent.com',
    iosBundleId: 'me.devloopers.one',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAmFkffOWyW73NQ9qln_kUTiM3Y0bPb6BY',
    appId: '1:1074945236940:ios:ca5b4b8bbdd8d199604769',
    messagingSenderId: '1074945236940',
    projectId: 'oneapp-af948',
    storageBucket: 'oneapp-af948.appspot.com',
    androidClientId: '1074945236940-5590q14ssqcpvpna5f1pdao4374v6909.apps.googleusercontent.com',
    iosClientId: '1074945236940-r90d8esa3ne2ec47q2msnmcau2ukbnnu.apps.googleusercontent.com',
    iosBundleId: 'com.example.one',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD2Rui9s4zYXRfZJgBTpxupTpBOehI61TU',
    appId: '1:1074945236940:web:f7d43b78548f8b48604769',
    messagingSenderId: '1074945236940',
    projectId: 'oneapp-af948',
    authDomain: 'oneapp-af948.firebaseapp.com',
    storageBucket: 'oneapp-af948.appspot.com',
    measurementId: 'G-QN8BF44M5K',
  );

}