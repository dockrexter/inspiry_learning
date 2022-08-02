import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/pages/user/home/home_page.dart';
import 'package:inspiry_learning/views/pages/admin/home/home_page.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';
import 'package:inspiry_learning/manager/shared_preferences_manager.dart';
import 'package:inspiry_learning/manager/firebase_notifications_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SharedPreferencesManager.instance.initPrefrences();
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
    FBNotificationManager().startFirebaseMessagingListener();
    FBNotificationManager().startFirebaseListenerOnMessageOpenedApp(
      (notification) => showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(notification.title!),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(notification.body!)],
              ),
            ),
          );
        },
      ),
    );
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
