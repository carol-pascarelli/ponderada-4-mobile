import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ponderada_4_mobile/firebase_options.dart';
import 'package:ponderada_4_mobile/src/app.dart';
import 'package:ponderada_4_mobile/src/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().initialize();

  runApp(const RemindersApp());
}
