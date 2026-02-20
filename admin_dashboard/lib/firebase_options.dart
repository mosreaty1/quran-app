// IMPORTANT: Replace placeholder values with your Firebase project config.
// This MUST match the firebase_options.dart in the mobile app (same project).
// Run: flutterfire configure  OR fill values manually below.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError('Admin dashboard is web-only.');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: '1:YOUR_PROJECT_NUMBER:web:YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_PROJECT_NUMBER',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );
}
