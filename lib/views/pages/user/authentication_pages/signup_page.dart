import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/assets_path.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/pages/user/home/home_page.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/user/authentication_pages/login_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
                  AppStrings.signUpAsUser,
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Image.asset(
                          AppAssets.frame,
                          scale: 3.5,
                        ),
                      ),
                      Text(
                        AppStrings.needAssignmentHelp,
                        style: AppStyle.textstylerobotoromanmedium14,
                      ),
                      InputTextField(
                        AppStrings.enterEmailAddress,
                        icon: const Icon(Icons.email),
                        controller: TextEditingController(),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(AppStrings.regexEmailValidation),
                          ),
                        ],
                      ),
                      InputTextField(
                        AppStrings.firstName,
                        icon: const Icon(Icons.person),
                        controller: TextEditingController(),
                      ),
                      InputTextField(
                        AppStrings.lastName,
                        icon: const Icon(Icons.person),
                        controller: TextEditingController(),
                      ),
                      InputTextField(
                        AppStrings.phoneNumber,
                        icon: const Icon(Icons.phone),
                        controller: TextEditingController(),
                      ),
                      InputTextField(
                        obscureText: true,
                        AppStrings.password,
                        icon: const Icon(Icons.lock),
                        controller: TextEditingController(),
                      ),
                      InputTextField(
                        AppStrings.confirmPassword,
                        icon: const Icon(Icons.lock),
                        controller: TextEditingController(),
                      ),
                      CustomButton(
                        AppStrings.signUp,
                        onPressed: () => AppRouter.push(
                          context,
                          const HomePage(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.haveAnAccount,
                            style: AppStyle.textstylepoppinsmedium14,
                          ),
                          const SizedBox(width: 6.0),
                          GestureDetector(
                            onTap: () =>
                                AppRouter.makeFirst(context, const LoginPage()),
                            child: Text(
                              AppStrings.signIn,
                              style: AppStyle.textstylepoppinsbold14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
