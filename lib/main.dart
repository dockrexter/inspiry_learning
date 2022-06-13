import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: AppStrings.appTitle,
      home: const UserInfoPage(),
    );
  }
}
