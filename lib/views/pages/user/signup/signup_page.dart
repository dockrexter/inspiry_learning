import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/app_assets.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/repositories/user_repositories.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
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
            height: ScreenSize.height * 0.20,
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
                      ),
                      InputTextField(
                        AppStrings.lastName,
                        icon: const Icon(Icons.person),
                        controller: _lastNameController,
                      ),
                      InputTextField(
                        AppStrings.phoneNumber,
                        icon: const Icon(Icons.phone),
                        controller: _phoneNumberController,
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
                              onPressed: () async => await _signUpBtnClickHandler(),
                            ),
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

  bool _checkIsAnyFieldIsEmpty(){
    return _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty;
  }

  bool _checkPasswordMatch(){
    return _passwordController.text == _confirmPasswordController.text;
  }

  void _emptyAllFields(){
    _emailController.clear();
    _passwordController.clear();
    _lastNameController.clear();
    _firstNameController.clear();
    _phoneNumberController.clear();
    _confirmPasswordController.clear();
  }

  Future<void> _signUpBtnClickHandler() async {
    if (_isLoading) return;
    if (_passwordController.text.length < 6) {
      Utils.showToast(AppStrings.passwordmustbe6characters);
      return;
    }
    if (!_checkPasswordMatch()) {
      Utils.showToast(AppStrings.passworddoesnotmatch);
      return;
    }
    if (_checkIsAnyFieldIsEmpty()) {
      Utils.showToast(AppStrings.allfieldsarerequired);
      return;
    }
    setState(() => _isLoading = true);
    final status = await UserRepository().signUp(
      user: User(
        email: _emailController.text,
        password: _passwordController.text,
        lastname: _lastNameController.text,
        phone: _phoneNumberController.text,
        firstname: _firstNameController.text,
      ),
    );
    setState(() => _isLoading = false);
    if (status) {
      _emptyAllFields();
      AppRouter.makeFirst(context, const LoginPage());
    }
  }
}
