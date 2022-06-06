import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/assets_path.dart';
import 'package:inspiry_learning/globals/user_type.dart';
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
            height: MediaQuery.of(context).size.height * 0.20,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
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
                  const SizedBox(height: 50),
                  CustomButton(
                    AppStrings.continueAsUser,
                    onPressed: () {
                      UserTypeHelper.continueAsUser();
                      _goToNextPage(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    AppStrings.continueAsAdmin,
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
