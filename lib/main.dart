import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:push_notification_app/Servises/notification_service.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('BACKGROUND MESSAGE RECEIVED');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  final NotificationService notificationService =
      NotificationService();

  await notificationService.initialize();
  await notificationService.getToken();

  notificationService.listenToMessages();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Push Notification App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Push Notification App'),
        ),
        body: const Center(
          child: Text(
            'Firebase Connected!!',
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}