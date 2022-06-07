import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/user_type.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/assets_path.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/pages/user/home/home_page.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/admin/home/home_page.dart';
import 'package:inspiry_learning/views/pages/user/signup/signup_page.dart';
import 'package:inspiry_learning/views/pages/common/authentication_pages/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;

  bool isAdmin = UserTypeHelper.isAdmin();

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
                  isAdmin ? AppStrings.loginAsAdmin : AppStrings.loginAsUser,
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
                          scale: 3,
                        ),
                      ),
                      if (!isAdmin)
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
                        obscureText: true,
                        AppStrings.enterPassword,
                        icon: const Icon(Icons.lock),
                        controller: TextEditingController(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      rememberMe = value ?? false;
                                    },
                                  );
                                },
                                activeColor: AppColors.yellow701,
                                side: const BorderSide(
                                  width: 1.5,
                                  color: AppColors.yellow701,
                                ),
                              ),
                              Text(
                                AppStrings.rememberMe,
                                style: AppStyle.textstylerobotoromanregular12,
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () => AppRouter.push(
                              context,
                              const ForgotPasswordPage(),
                            ),
                            child: Text(
                              AppStrings.forgotPassword,
                              style: AppStyle.textstylerobotoromanregular10,
                            ),
                          )
                        ],
                      ),
                      CustomButton(
                        AppStrings.login,
                        onPressed: () => AppRouter.push(
                          context,
                          isAdmin ? const AdminHomePage() : const HomePage(),
                        ),
                      ),
                      if (!isAdmin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.dontHaveAnAccount,
                              style: AppStyle.textstylepoppinsmedium14,
                            ),
                            const SizedBox(width: 6.0),
                            GestureDetector(
                              onTap: () => AppRouter.makeFirst(
                                  context, const SignUpPage()),
                              child: Text(
                                AppStrings.signUp,
                                style: AppStyle.textstylepoppinsbold14,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
