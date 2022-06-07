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
import 'package:inspiry_learning/views/pages/common/authentication_pages/forgot_password_page.dart';

class AddSubAdminPage extends StatefulWidget {
  const AddSubAdminPage({Key? key}) : super(key: key);

  @override
  State<AddSubAdminPage> createState() => _AddSubAdminPageState();
}

class _AddSubAdminPageState extends State<AddSubAdminPage> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.18,
            child: SafeArea(
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: AppColors.white,
                    ),
                    onPressed: () => AppRouter.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    AppStrings.addSubAdmin,
                    style: AppStyle.textstyleinterbold23.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
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
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Image.asset(
                          AppAssets.frame,
                          scale: 3,
                        ),
                      ),
                      InputTextField(
                        AppStrings.fullName,
                        icon: const Icon(Icons.person),
                        controller: TextEditingController(),
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
                        AppStrings.registerSubAdmin,
                        onPressed: () => AppRouter.push(
                          context,
                          const HomePage(),
                        ),
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
