import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Notification permission
  Future<void> requestPermission() async {
    NotificationSettings settings =
        await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print(
      'Permission status: ${settings.authorizationStatus}',
    );
  }

  // Get FCM Token
  Future<void> getToken() async {
    String? token = await _messaging.getToken();

    print('FCM TOKEN: $token');
  }
}