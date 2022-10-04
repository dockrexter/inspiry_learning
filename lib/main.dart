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
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';
import 'package:inspiry_learning/manager/shared_preferences_manager.dart';
import 'package:inspiry_learning/manager/firebase_notifications_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('notificationcounter');
  Hive.box('notificationcounter').put('count', 0);

  await Firebase.initializeApp();
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const HandleNotification(),
    );
  }
}

class HandleNotification extends StatefulWidget {
  const HandleNotification({Key? key}) : super(key: key);
  @override
  State<HandleNotification> createState() => _HandleNotificationState();
}

class _HandleNotificationState extends State<HandleNotification> {
  @override
  void initState() {
    super.initState();
    const androidInitialize =
        AndroidInitializationSettings('notification_icon');
    const iOSInitialize = IOSInitializationSettings();
    const initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin!.initialize(initializationsSettings,
        onSelectNotification: (payload) {
      if (payload != null) {
        if (payload.isNotEmpty) {
          AppRouter.push(context, ChatPage(assaignmentid: payload));
        }
      }
    });
    FBNotificationManager.initialize(flutterLocalNotificationsPlugin!);
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async =>
        await FBNotificationManager.showBigTextNotification(
          message,
          flutterLocalNotificationsPlugin!,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ActiveUser.instance.user == null ||
            ActiveUser.instance.user?.token == null
        ? const UserInfoPage()
        : UserTypeHelper.isAdmin()
            ? const AdminHomePage()
            : const HomePage();
  }
}
