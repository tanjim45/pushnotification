import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Firebase notification permission + local notification setup
  Future<void> initialize() async {
    // Firebase notification permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Local notification permission
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
    );

    // Notification channel
    const AndroidNotificationChannel channel =
        AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // FCM Token
  Future<void> getToken() async {
    String? token = await _messaging.getToken();

    print('FCM TOKEN: $token');
  }

  // App খোলা থাকা অবস্থায় message receive
  void listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('==============================');
      print('NOTIFICATION RECEIVED');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('==============================');

      final RemoteNotification? notification = message.notification;

      if (notification != null) {
        _showNotification(
          notification.title ?? 'Notification',
          notification.body ?? '',
        );
      }
    });
  }

  // Phone notification popup + sound
  Future<void> _showNotification(
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription:
          'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}