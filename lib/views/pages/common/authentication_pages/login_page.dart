import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/repositories/user_repositories.dart';
import 'package:inspiry_learning/views/pages/user/home/home_page.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/admin/home/home_page.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';
import 'package:inspiry_learning/views/pages/user/signup/signup_page.dart';
import 'package:inspiry_learning/views/pages/common/authentication_pages/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _rememberMe = true;
  final _isAdmin = UserTypeHelper.isAdmin();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SizedBox(
            height: ScreenSize.height * 0.16,
            child: Padding(
              padding: EdgeInsets.only(top: 50.h, left: 20.h),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: AppColors.white,
                    ),
                    onPressed: () =>
                        AppRouter.makeFirst(context, const UserInfoPage()),
                  ),
                  SizedBox(width: UserTypeHelper.isAdmin() ? 14.w : 46.w),
                  Text(
                    _isAdmin
                        ? AppStrings.loginAsProfessional
                        : AppStrings.loginAsUser,
                    style: AppStyle.textstyleinterbold23.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
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
                      if (!_isAdmin)
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
                        obscureText: true,
                        AppStrings.enterPassword,
                        icon: const Icon(Icons.lock),
                        controller: _passwordController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) => setState(
                                    () => _rememberMe = value ?? false),
                                activeColor: AppColors.yellow701,
                                side: BorderSide(
                                  width: 1.5.w,
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
                              style: AppStyle.textstylerobotoromanregular12,
                            ),
                          )
                        ],
                      ),
                      _isLoading
                          ? const CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.yellow701,
                              ),
                            )
                          : CustomButton(
                              AppStrings.login,
                              onPressed: () async =>
                                  await _loginBtnClickHandler(),
                            ),
                      if (!_isAdmin)
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
                                    style: AppStyle.textstylepoppinsbold14
                                        .copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.dontHaveAnAccount,
                                  style: AppStyle.textstylepoppinsmedium14,
                                ),
                                SizedBox(width: 6.w),
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

  dynamic getControllers() => [
        _emailController,
        _passwordController,
      ];

  Future<void> _loginBtnClickHandler() async {
    if (_isLoading) return;
    if (AppUtils.checkIsAnyFieldIsEmpty(controllers: getControllers())) {
      AppUtils.showToast(AppStrings.allFieldsAreRequired);
      return;
    }
    if (_passwordController.text.length < 6) {
      AppUtils.showToast(AppStrings.passwordMustBe6Characters);
      return;
    }
    setState(() => _isLoading = true);
    ActiveUser.instance.user = await UserRepository().login(
      email: _emailController.text,
      password: _passwordController.text,
      rememberMe: _rememberMe,
      role: AppUtils.role,
    );
    setState(() => _isLoading = false);
    if (ActiveUser.instance.user != null) {
      AppUtils.clearAllFields(controllers: getControllers());
      AppRouter.makeFirst(
        context,
        _isAdmin ? const AdminHomePage() : const HomePage(),
      );
    }
  }
}
