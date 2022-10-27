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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FBNotificationManager.showBigTextNotification(
    message,
    flutterLocalNotificationsPlugin!,
  );
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
  void _setupInteractedMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.data["title"] == "New Message") {
        Future.delayed(
          const Duration(seconds: 5),
          () => AppRouter.push(
            context,
            ChatPage(assaignmentid: message.data["assignmentId"]),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _setupInteractedMessage());

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

    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitialize = IOSInitializationSettings();
    const initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin!.initialize(initializationsSettings,
        onSelectNotification: (payload) {
      if (payload != null) {
        if (payload.isNotEmpty) {
          Future.delayed(
            const Duration(seconds: 5),
            () => AppRouter.push(context, ChatPage(assaignmentid: payload)),
          );
        }
      }
    });
    FBNotificationManager.initialize(flutterLocalNotificationsPlugin!);
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.width = MediaQuery.of(context).size.width;
    ScreenSize.height = MediaQuery.of(context).size.height;
    UserTypeHelper.initUserType();
    return MaterialApp(
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
