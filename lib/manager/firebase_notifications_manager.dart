import 'package:hive_flutter/adapters.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FBNotificationManager {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin localNotificationsPlugin) async {
    await Hive.initFlutter();
    await Hive.openBox('notificationcounter');
    final Box _countBox = Hive.box('notificationcounter');

    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      int count = _countBox.get('count', defaultValue: 0);
      _countBox.put('count', ++count);
      await showBigTextNotification(message, localNotificationsPlugin);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async =>
        await showBigTextNotification(message, localNotificationsPlugin));
  }

  static Future<void> showBigTextNotification(
      RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
    final title = message.data['title']!;
    final body = message.data['body']!;
    final assignmentId = title == "New Message"
        ? message.data['assignmentId']!.toString()
        : null;
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body ?? "",
      htmlFormatBigText: true,
      contentTitle: title ?? "",
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      AppStrings.notificationId,
      AppStrings.notificationName,
      channelDescription: AppStrings.notificationDescription,
      playSound: true,
      channelShowBadge: true,
      priority: Priority.max,
      importance: Importance.max,
      icon: "@mipmap/ic_launcher",
      styleInformation: bigTextStyleInformation,
      visibility: NotificationVisibility.public,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics,
        payload: assignmentId);
  }
}
