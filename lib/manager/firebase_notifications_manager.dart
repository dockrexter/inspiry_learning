import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:inspiry_learning/main.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FBNotificationManager extends ChangeNotifier {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    final Box _countBox = Hive.box('notificationcounter');
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onSelectNotification: (String? payload) async {
      try {
        if (payload != null && payload.isNotEmpty) {}
      } catch (_) {}
      return;
    });

    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await Hive.initFlutter();
      await Hive.openBox('notificationcounter');
      int count = _countBox.get('count', defaultValue: 0);
      _countBox.put('count', ++count);

      showNotification(message, flutterLocalNotificationsPlugin, false);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await Hive.initFlutter();
      await Hive.openBox('notificationcounter');
      int count = _countBox.get('count', defaultValue: 0);
      _countBox.put('count', ++count);
      showNotification(message, flutterLocalNotificationsPlugin, false);
      try {
        if (message.notification?.titleLocKey != null &&
            message.notification!.titleLocKey!.isNotEmpty) {}
      } catch (_) {}
    });
  }

  static Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin fln, bool data) async {
    String? _title;
    String? _body;
    String _orderID;

    _title = message.data['title']!;
    _body = message.data['body']!;
    _orderID = 'ff';

    await showBigTextNotification(_title, _body, _orderID, fln);
  }

  static Future<void> showTextNotification(String title, String body,
      String orderID, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      AppStrings.notificationId,
      AppStrings.notificationName,
      channelDescription: AppStrings.notificationDescription,
      playSound: false,
      importance: Importance.max,
      priority: Priority.max,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigTextNotification(String? title, String? body,
      String orderID, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        body ?? "",
        htmlFormatBigText: true,
        contentTitle: title ?? "",
        htmlFormatContentTitle: true);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            AppStrings.notificationId, AppStrings.notificationName,
            channelDescription: AppStrings.notificationDescription,
            importance: Importance.max,
            styleInformation: bigTextStyleInformation,
            priority: Priority.max,
            playSound: false
            // sound:const RawResourceAndroidNotificationSound('notification'),
            );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  await Hive.initFlutter();
  await Hive.openBox('notificationcounter');
  final Box _countBox = Hive.box('notificationcounter');
  int count = _countBox.get('count', defaultValue: 0);
  _countBox.put('count', ++count);
  FBNotificationManager.showNotification(
    message,
    flutterLocalNotificationsPlugin!,
    false,
  );
}
