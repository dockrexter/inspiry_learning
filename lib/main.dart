import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/user_type.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/views/pages/user/home/home_page.dart';
import 'package:inspiry_learning/views/pages/admin/home/home_page.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';
import 'package:inspiry_learning/manager/shared_preferences_manager.dart';
import 'package:inspiry_learning/views/pages/common/authentication_pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SharedPreferencesManager.instance.initPrefrences();
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
    final _token = SharedPreferencesManager.instance.getToken();
    final _isUserTypeInitialized = UserTypeHelper.initUserType();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: AppStrings.appTitle,
      home: _isUserTypeInitialized
          ? _token == null
              ? const LoginPage()
              : UserTypeHelper.isAdmin()
                  ? const AdminHomePage()
                  : const HomePage()
          : const UserInfoPage(),
    );
  }
}
