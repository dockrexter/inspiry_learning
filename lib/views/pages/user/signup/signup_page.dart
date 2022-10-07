import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/repositories/user_repositories.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/user/home/home_page.dart';
import 'package:inspiry_learning/views/pages/common/authentication_pages/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SizedBox(
            height: ScreenSize.height * 0.18,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
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
                  height: ScreenSize.height * 0.80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Image.asset(
                          AppAssets.frame,
                          scale: 3,
                        ),
                      ),
                      Text(
                        AppStrings.needAssignmentHelp,
                        style: AppStyle.textstylerobotoromanmedium14,
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
                      InputTextField(
                        AppStrings.firstName,
                        icon: const Icon(Icons.person),
                        controller: _firstNameController,
                        keyboardType: TextInputType.name,
                      ),
                      InputTextField(
                        AppStrings.lastName,
                        icon: const Icon(Icons.person),
                        controller: _lastNameController,
                        keyboardType: TextInputType.name,
                      ),
                      InputTextField(
                        AppStrings.phoneNumber,
                        icon: const Icon(Icons.phone),
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                      ),
                      InputTextField(
                        obscureText: true,
                        AppStrings.password,
                        icon: const Icon(Icons.lock),
                        controller: _passwordController,
                      ),
                      InputTextField(
                        obscureText: true,
                        AppStrings.confirmPassword,
                        icon: const Icon(Icons.lock),
                        controller: _confirmPasswordController,
                      ),
                      _isLoading
                          ? const CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.yellow701,
                              ),
                            )
                          : CustomButton(
                              AppStrings.signUp,
                              onPressed: () async =>
                                  await _signUpBtnClickHandler(),
                            ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.agreeToAll,
                                style: AppStyle.textstylepoppinsmedium14,
                              ),
                              SizedBox(width: 6.w),
                              GestureDetector(
                                onTap: () async => await AppUtils.launchURL(
                                    AppStrings.termsAndConditionsUrl),
                                child: Text(
                                  AppStrings.termsAndConditions,
                                  style:
                                      AppStyle.textstylepoppinsbold14.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.haveAnAccount,
                                style: AppStyle.textstylepoppinsmedium14,
                              ),
                              SizedBox(width: 6.w),
                              GestureDetector(
                                onTap: () =>
                                    AppRouter.makeFirst(context, const LoginPage()),
                                child: Text(
                                  AppStrings.signIn,
                                  style: AppStyle.textstylepoppinsbold14,
                                ),
                              ),
                            ],
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

  dynamic getControllers() => [
        _emailController,
        _passwordController,
        _lastNameController,
        _firstNameController,
        _phoneNumberController,
        _confirmPasswordController,
      ];

  Future<void> _signUpBtnClickHandler() async {
    if (_isLoading) return;
    if (AppUtils.checkIsAnyFieldIsEmpty(controllers: getControllers())) {
      AppUtils.showToast(AppStrings.allFieldsAreRequired);
      return;
    }
    if (!AppUtils.isPasswordMatched(
        controllers: [_passwordController, _confirmPasswordController])) {
      AppUtils.showToast(AppStrings.passwordDoesNotMatch);
      return;
    }
    if (_passwordController.text.length < 6) {
      AppUtils.showToast(AppStrings.passwordMustBe6Characters);
      return;
    }
    setState(() => _isLoading = true);
    ActiveUser.instance.user = await UserRepository().signUp(
      user: User(
        role: AppUtils.role,
        email: _emailController.text,
        password: _passwordController.text,
        lastname: _lastNameController.text,
        phone: _phoneNumberController.text,
        firstname: _firstNameController.text,
      ),
    );
    setState(() => _isLoading = false);
    if (ActiveUser.instance.user != null) {
      AppUtils.clearAllFields(controllers: getControllers());
      AppRouter.makeFirst(context, const HomePage());
    }
  }
}
