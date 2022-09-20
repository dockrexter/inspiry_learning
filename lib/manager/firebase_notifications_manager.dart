import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';

import '../globals/app_strings.dart';
import '../main.dart';

class FBNotificationManager extends ChangeNotifier {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    // await Hive.openBox('notificationcounter');
    final Box _countBox = Hive.box('notificationcounter');
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onSelectNotification: (String? payload) async {
      // print('??????????????????????????????????????');
      // print(payload);
      try {
        if (payload != null && payload.isNotEmpty) {
          //When Payload is Empty
        }
        // print("payload daaaaaaaaaaaaaaaa");
        // print(payload);

        ///
      } catch (e) {
        // print(e.toString());
      }
      return;
    });

    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      print(
          "onMessage: ${message.data['title']}/${message.data['body']}/${message.data.toString()}");
           await Hive.initFlutter();
  await Hive.openBox('notificationcounter');
      int count = _countBox.get('count', defaultValue: 0);
      _countBox.put('count', ++count);

      showNotification(message, flutterLocalNotificationsPlugin, false);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(
          "onMessageOpenedApp: ${message.data['title']}/${message.data['body']}/${message.data.toString()}");
      await Hive.initFlutter();
      await Hive.openBox('notificationcounter');
      int count = _countBox.get('count', defaultValue: 0);
      _countBox.put('count', ++count);
      showNotification(message, flutterLocalNotificationsPlugin, false);
      try {
        if (message.notification?.titleLocKey != null &&
            message.notification!.titleLocKey!.isNotEmpty) {}
      } catch (e) {
        print(e.toString());
      }
    });
  }

  static Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin fln, bool data) async {
    String? _title;
    String? _body;
    String _orderID;
    String _image;
    // if (data) {
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
      importance: Importance.max, priority: Priority.max,
      // sound: RawResourceAndroidNotificationSound('notification'),
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

  // FBNotificationManager._internal();

  // factory FBNotificationManager() => _instance;

  // static final FBNotificationManager _instance =
  //     FBNotificationManager._internal();

  // final _channel = const AndroidNotificationChannel(
  //   AppStrings.notificationId,
  //   AppStrings.notificationName,
  //   description: AppStrings.notificationDescription,
  //   importance: Importance.high,
  //   playSound: true,
  // );

  // final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Future<String?> getToken() async {
  //   return await FirebaseMessaging.instance.getToken();
  // }

  // Future<void> regiterNotificationService() async {
  //   FirebaseMessaging.onBackgroundMessage(
  //       (_) async => await Firebase.initializeApp());

  //   await _flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(_channel);

  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  // }

  // void startFirebaseListenerOnMessageOpenedApp(dynamic callback) {
  //   FirebaseMessaging.onMessageOpenedApp.listen(
  //     (RemoteMessage message) {
  //       RemoteNotification? notification = message.notification;
  //       AndroidNotification? android = message.notification?.android;
  //       if (notification != null && android != null) {
  //         callback(notification);
  //       }
  //     },
  //   );
  // }

  // void startFirebaseMessagingListener() {
  //   FirebaseMessaging.onMessage.listen(
  //     (RemoteMessage message) {
  //       RemoteNotification? notification = message.notification;
  //       AndroidNotification? android = message.notification?.android;
  //       print(message.notification!.title);
  //       print(message.notification!.body);

  //       if (notification != null && android != null) {
  //         _flutterLocalNotificationsPlugin.show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               _channel.id,
  //               _channel.name,
  //               playSound: true,
  //               color: AppColors.teal400,
  //               channelDescription: _channel.description,
  //             ),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print(
      "onMessageBackground: ${message.data['title']}/${message.data['body']}/${message.data.toString()}");
  // await Hive.openBox('notificationcounter');
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
