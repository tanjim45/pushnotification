import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_app/Servises/notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationService notificationService = NotificationService();

  await notificationService.requestPermission();
  await notificationService.getToken();

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
            'Firebase Connected!',
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}