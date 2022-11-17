import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/pages/user/home/home_page.dart';
import 'package:inspiry_learning/views/pages/admin/home/home_page.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/manager/shared_preferences_manager.dart';
import 'package:inspiry_learning/manager/firebase_notifications_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FBNotificationManager.showBigTextNotification(
    message,
    flutterLocalNotificationsPlugin!,
  );
}

void _onDidReceiveNotificationResponse(NotificationResponse response) async {
  if (response.payload != null) {
    if (response.payload!.isNotEmpty) {
      await Future.delayed(
        const Duration(milliseconds: 100),
        () async => await Get.to(
          () => ChatPage(assaignmentid: response.payload),
        ),
      );
    }
  }
}

@pragma('vm:entry-point')
Future<dynamic> _onDidReceiveBackgroundNotificationResponse(
    RemoteMessage? message) async {
  if (message == null) return;
  final title = message.data['title'];
  if (title == null) return;
  final assignmentId =
      title == "New Message" ? message.data['assignmentId'].toString() : null;
  if (assignmentId != null) {
    if (assignmentId.isNotEmpty) {
      await Future.delayed(
        const Duration(seconds: 2),
        () async => await Get.to(
          () => ChatPage(assaignmentid: assignmentId),
        ),
      );
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Hive.initFlutter();
  await Hive.openBox('notificationcounter');
  Hive.box('notificationcounter').put('count', 0);

  await SharedPreferencesManager.instance.initPrefrences();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  ActiveUser.instance.user = await User.getUser();

  runApp(
    ScreenUtilInit(
      builder: (context, _) => const MyApp(),
      designSize: const Size(375, 812),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          AppStrings.notificationId,
          AppStrings.notificationName,
          description: AppStrings.notificationDescription,
          importance: Importance.max,
          playSound: true,
          showBadge: true,
        ));

    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitializationSettings = DarwinInitializationSettings();

    const initializationsSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    flutterLocalNotificationsPlugin!.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    FBNotificationManager.initialize(flutterLocalNotificationsPlugin!);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOnMessageOpenedApp);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(_onDidReceiveBackgroundNotificationResponse);
  }

  Future<void> _handleOnMessageOpenedApp(RemoteMessage message) async {
    final title = message.data['title'];
    if (title == null) return;
    // if (title == 'Assignment Status') {
    //   return await Get.forceAppUpdate();
    // }
    final assignmentId = (title == "New Message" || title == "New Assignment")
        ? message.data['assignmentId'].toString()
        : null;
    if (assignmentId != null) {
      if (assignmentId.isNotEmpty) {
        await Future.delayed(
          const Duration(seconds: 1),
          () async => await Get.to(
            () => ChatPage(assaignmentid: assignmentId),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.width = MediaQuery.of(context).size.width;
    ScreenSize.height = MediaQuery.of(context).size.height;
    UserTypeHelper.initUserType();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: AppStrings.appTitle,
      home: ActiveUser.instance.user == null ||
              ActiveUser.instance.user?.token == null
          ? const UserInfoPage()
          : UserTypeHelper.isAdmin()
              ? const AdminHomePage()
              : const HomePage(),
    );
  }
}
