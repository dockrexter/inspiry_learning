import 'package:firebase_core/firebase_core.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FBNotificationManager {
  FBNotificationManager._internal();

  factory FBNotificationManager() => _instance;

  static final FBNotificationManager _instance =
      FBNotificationManager._internal();

  final _channel = const AndroidNotificationChannel(
    AppStrings.notificationId,
    AppStrings.notificationName,
    description: AppStrings.notificationDescription,
    importance: Importance.high,
    playSound: true,
  );

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> regiterNotificationService() async {
    FirebaseMessaging.onBackgroundMessage(
        (_) async => await Firebase.initializeApp());

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void startFirebaseListenerOnMessageOpenedApp(dynamic callback) {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          callback(notification);
        }
      },
    );
  }

  void startFirebaseMessagingListener() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          _flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                playSound: true,
                color: AppColors.teal400,
                channelDescription: _channel.description,
              ),
            ),
          );
        }
      },
    );
  }
}
