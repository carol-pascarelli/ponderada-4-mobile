import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Plataforma Web não configurada.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('DefaultFirebaseOptions não suporta esta plataforma.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPza0U3yf9IJAI-klGoc1ipKtuq5Cep2o',
    appId: '1:1039273066449:android:3631f4d854405b962e2af0',
    messagingSenderId: '1039273066449',
    projectId: 'reminders-e1f6a',
    storageBucket: 'reminders-e1f6a.firebasestorage.app',
  );
}