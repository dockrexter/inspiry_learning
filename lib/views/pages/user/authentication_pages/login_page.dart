import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/assets_path.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/user/authentication_pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  AppStrings.loginAsUser,
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
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Image.asset(
                      AppAssets.frame,
                      scale: 3.5,
                    ),
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
                            style: TextStyle(
                              color: AppColors.black1e1100.withOpacity(0.3),
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                      Text(
                        AppStrings.forgotPassword,
                        style: TextStyle(
                          color: AppColors.black1e1100.withOpacity(0.3),
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  CustomButton(
                    AppStrings.login,
                    color: AppColors.yellow701,
                    onPressed: () {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.dontHaveAnAccount,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black1e1100.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      GestureDetector(
                        onTap: () =>
                            AppRouter.makeFirst(context, const SignUpPage()),
                        child: Text(
                          AppStrings.signUp,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.yellow701.withOpacity(0.75),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
