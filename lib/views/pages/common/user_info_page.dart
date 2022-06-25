import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/pages/common/authentication_pages/login_page.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SizedBox(
            height: ScreenSize.height * 0.20,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  AppStrings.appTitle,
                  style: AppStyle.textstyleinterbold23.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.r),
                  topLeft: Radius.circular(40.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      AppAssets.frame,
                      scale: 2,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Text(
                    AppStrings.needAssignmentHelp,
                    style: AppStyle.textstylerobotoromanmedium14,
                  ),
                  SizedBox(height: 50.h),
                  CustomButton(
                    AppStrings.continueAsUser,
                    onPressed: () {
                      UserTypeHelper.continueAsUser();
                      _goToNextPage(context);
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    AppStrings.continueAsProfessional,
                    onPressed: () {
                      UserTypeHelper.continueAsAdmin();
                      _goToNextPage(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToNextPage(BuildContext context) {
    AppRouter.makeFirst(context, const LoginPage());
  }
}
