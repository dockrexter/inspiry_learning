import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/repositories/user_repositories.dart';
import 'package:inspiry_learning/views/pages/user/home/home_page.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/admin/home/home_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isLoading = false;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
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
                    AppStrings.changePassword,
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
                  height: ScreenSize.height * 0.80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Image.asset(
                          AppAssets.keyFrame,
                          scale: 2.8,
                        ),
                      ),
                      Column(
                        children: [
                          InputTextField(
                            obscureText: true,
                            AppStrings.currentPassword,
                            icon: const Icon(Icons.lock),
                            controller: _oldPasswordController,
                          ),
                          SizedBox(height: 12.h),
                          InputTextField(
                            obscureText: true,
                            AppStrings.newPassword,
                            icon: const Icon(Icons.lock),
                            controller: _newPasswordController,
                          ),
                          SizedBox(height: 12.h),
                          InputTextField(
                            obscureText: true,
                            AppStrings.confirmNewPassword,
                            icon: const Icon(Icons.lock),
                            controller: _confirmPasswordController,
                          ),
                        ],
                      ),
                      _isLoading
                          ? const CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.yellow701,
                              ),
                            )
                          : CustomButton(
                              AppStrings.done,
                              onPressed: () async =>
                                  await _changePasswordBtnClickHandler(),
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
        _oldPasswordController,
        _newPasswordController,
        _confirmPasswordController,
      ];

  Future<void> _changePasswordBtnClickHandler() async {
    if (_isLoading) return;
    if (Utils.checkIsAnyFieldIsEmpty(controllers: getControllers())) {
      Utils.showToast(AppStrings.allfieldsarerequired);
      return;
    }
    if (!Utils.isPasswordMatched(
        controllers: [_newPasswordController, _confirmPasswordController])) {
      Utils.showToast(AppStrings.passworddoesnotmatch);
      return;
    }
    if (_newPasswordController.text.length < 6) {
      Utils.showToast(AppStrings.passwordmustbe6characters);
      return;
    }
    if (ActiveUser.userId == null) {
      Utils.showToast(AppStrings.somethingWentWrong);
      return;
    }
    setState(() => _isLoading = true);
    final status = await UserRepository().changePassword(
      userId: ActiveUser.userId!,
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );
    setState(() => _isLoading = false);
    if (status) {
      Utils.showToast(AppStrings.passwordchangedsuccessfully);
      Utils.clearAllFields(controllers: getControllers());
      AppRouter.makeFirst(context,
          UserTypeHelper.isAdmin() ? const AdminHomePage() : const HomePage());
    }
  }
}
