import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Firebase Messaging
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Local Notification
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Notification Channel ID
  static const String channelId = 'high_importance_channel';

  // Notification Channel Name
  static const String channelName = 'High Importance Notifications';



  Future<void> initialize() async {
    //  Firebase notification permission
 

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Android notification permission
   

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    //  Initialize local notification

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
    );

    //  Create HIGH IMPORTANCE notification channel

    const AndroidNotificationChannel channel =
        AndroidNotificationChannel(
      channelId,
      channelName,
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await androidPlugin?.createNotificationChannel(channel);
  }

  // GET FCM TOKEN

  Future<void> getToken() async {
    try {
      final String? token = await _messaging.getToken();

      print('======================================');
      print('FCM TOKEN:');
      print(token);
      print('======================================');
    } catch (e) {
      print('FCM TOKEN ERROR: $e');
    }
  }

  // LISTEN TO FOREGROUND MESSAGES

  void listenToMessages() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print('======================================');
        print('NOTIFICATION RECEIVED');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('======================================');

        final RemoteNotification? notification = message.notification;

        if (notification != null) {
          _showNotification(
            notification.title ?? 'Notification',
            notification.body ?? '',
          );
        }
      },
    );
  }

  // SHOW LOCAL NOTIFICATION

  Future<void> _showNotification(
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription:
          'This channel is used for important notifications.',

      // Popup importance
      importance: Importance.max,

      // Heads-up notification
      priority: Priority.max,

      // Sound
      playSound: true,

      // Vibration
      enableVibration: true,

      // Badge
      showWhen: true,

      // Notification icon
      icon: '@mipmap/ic_launcher',
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
