import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/repositories/user_repositories.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SizedBox(
            height: ScreenSize.height * 0.35,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
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
                        padding: EdgeInsets.only(top: 20.h, left: 6.w),
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
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.r),
                  topLeft: Radius.circular(40.r),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: SizedBox(
                  height: ScreenSize.height * 0.65,
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(AppStrings.regexEmailValidation),
                          ),
                        ],
                      ),
                      CustomButton(
                        AppStrings.send,
                        onPressed: () async {
                          await UserRepository().forgotPassword(
                            email: _emailController.text,
                          );
                          await _buildDialog(context);
                        },
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

  Future<dynamic> _buildDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.r),
          ),
        ),
        contentPadding: const EdgeInsets.all(0.0),
        content: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.h),
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.yellow701,
                child: const Icon(
                  Icons.email,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                AppStrings.emailSent,
                style: AppStyle.textstylepoppinssemibold14.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                AppStrings.checkInbox,
                style: AppStyle.textstylepoppinsregular12,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              AppStrings.login,
              style: AppStyle.textstylepoppinssemibold12.copyWith(
                fontSize: 16.sp,
              ),
            ),
            onPressed: () {
              AppRouter.pop(context);
              AppRouter.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
