import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/assets_path.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        AppAssets.lock,
                        scale: 2.8,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 6.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: AppColors.white,
                          ),
                          onPressed: () => AppRouter.pop(context),
                        ),
                      ),
                    ),
                  ],
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
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        AppStrings.forgotPassword,
                        style: AppStyle.textstylepoppinsbold20,
                      ),
                      Text(
                        AppStrings.enterEmailForVerification,
                        textAlign: TextAlign.center,
                        style: AppStyle.textstylepoppinsbold12,
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
                      CustomButton(
                        AppStrings.send,
                        onPressed: () {},
                      ),
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
