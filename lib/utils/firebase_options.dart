import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyASid6rGwNihcOMLhXsN2YM3y48yhoj3l4',
    authDomain: 'flutter-1-f7f21.firebaseapp.com',
    projectId: 'flutter-1-f7f21',
    storageBucket: 'flutter-1-f7f21.firebasestorage.app',
    messagingSenderId: '1075512034362',
    appId: '1:1075512034362:web:62d1736e267d2540556103',
    measurementId: 'G-RDG7VK5ZYN',
  );
}
