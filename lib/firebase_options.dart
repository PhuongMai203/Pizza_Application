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
    apiKey: 'AIzaSyDaoX8UCu2amH1Hm-VxbiCZEhlB4Jex-w8',
    appId: '1:475779901254:web:279ad99b4ae145b9992747',
    messagingSenderId: '475779901254',
    projectId: 'pizza-delivery-86de3',
    authDomain: 'pizza-delivery-86de3.firebaseapp.com',
    storageBucket: 'pizza-delivery-86de3.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXcjFTLM6vMjLY-L337c1pXoMzPnaO4IM',
    appId: '1:475779901254:android:5e327ca3547ab444992747',
    messagingSenderId: '475779901254',
    projectId: 'pizza-delivery-86de3',
    storageBucket: 'pizza-delivery-86de3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJpUvgzDvi3GJZmFav_ACYrJjXNZVloH8',
    appId: '1:475779901254:ios:774390f131066f72992747',
    messagingSenderId: '475779901254',
    projectId: 'pizza-delivery-86de3',
    storageBucket: 'pizza-delivery-86de3.firebasestorage.app',
    iosBundleId: 'com.example.pizzaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAJpUvgzDvi3GJZmFav_ACYrJjXNZVloH8',
    appId: '1:475779901254:ios:774390f131066f72992747',
    messagingSenderId: '475779901254',
    projectId: 'pizza-delivery-86de3',
    storageBucket: 'pizza-delivery-86de3.firebasestorage.app',
    iosBundleId: 'com.example.pizzaApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDaoX8UCu2amH1Hm-VxbiCZEhlB4Jex-w8',
    appId: '1:475779901254:web:b02bb8f5f64a573d992747',
    messagingSenderId: '475779901254',
    projectId: 'pizza-delivery-86de3',
    authDomain: 'pizza-delivery-86de3.firebaseapp.com',
    storageBucket: 'pizza-delivery-86de3.firebasestorage.app',
  );

}