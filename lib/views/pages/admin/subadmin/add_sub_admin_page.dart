import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/repositories/user_repositories.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/admin/home/home_page.dart';

class AddSubAdminPage extends StatefulWidget {
  const AddSubAdminPage({Key? key}) : super(key: key);

  @override
  State<AddSubAdminPage> createState() => _AddSubAdminPageState();
}

class _AddSubAdminPageState extends State<AddSubAdminPage> {
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
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
                      SizedBox(height: 50.h),
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

  dynamic getControllers() => [
        _emailController,
        _passwordController,
        _lastNameController,
        _firstNameController,
      ];

  Future<void> _registerBtnClickHandler() async {
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
    final user = await UserRepository().signUp(
      user: User(
        phone: '',
        role: AppUtils.role,
        firstname: _firstNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        lastname: _lastNameController.text,
      ),
      addSubAdmin: true,
    );
    setState(() => _isLoading = false);
    if (user != null) {
      AppUtils.clearAllFields(controllers: getControllers());
      AppUtils.showToast(AppStrings.subAdminAddedSuccessfully);
      AppRouter.makeFirst(context, const AdminHomePage());
    }
  }
}
