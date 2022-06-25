import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/repositories/user_repositories.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/admin/home/home_page.dart';
import 'package:inspiry_learning/views/pages/common/authentication_pages/forgot_password_page.dart';

class AddSubAdminPage extends StatefulWidget {
  const AddSubAdminPage({Key? key}) : super(key: key);

  @override
  State<AddSubAdminPage> createState() => _AddSubAdminPageState();
}

class _AddSubAdminPageState extends State<AddSubAdminPage> {
  bool rememberMe = false;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
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
            child: SafeArea(
              child: Row(
                children: [
                  SizedBox(width: 8.w),
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
                  height: ScreenSize.height * 0.82,
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
                        controller: _fullNameController,
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
                                value: rememberMe,
                                onChanged: (value) =>
                                    setState(() => rememberMe = value ?? false),
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
                              AppStrings.registerSubAdmin,
                              onPressed: () async =>
                                  await _registerBtnClickHandler(),
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

  bool _checkIsAnyFieldIsEmpty() {
    return _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _fullNameController.text.isEmpty;
  }

  void _emptyAllFields() {
    _emailController.clear();
    _passwordController.clear();
    _fullNameController.clear();
  }

  Future<void> _registerBtnClickHandler() async {
    if (_isLoading) return;
    if (_passwordController.text.length < 6) {
      Utils.showToast(AppStrings.passwordmustbe6characters);
      return;
    }
    if (_checkIsAnyFieldIsEmpty()) {
      Utils.showToast(AppStrings.allfieldsarerequired);
      return;
    }
    setState(() => _isLoading = true);
    final user = await UserRepository().signUp(
      user: User(
        email: _emailController.text,
        password: _passwordController.text,
        firstname: _fullNameController.text,
      ),
    );
    setState(() => _isLoading = false);
    if (user != null) {
      _emptyAllFields();
      AppRouter.makeFirst(context, const AdminHomePage());
    }
  }
}
