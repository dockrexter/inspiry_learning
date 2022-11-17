import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/user_type.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/repositories/user_repositories.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';
import 'package:inspiry_learning/views/pages/admin/addadmin/add_admin_page.dart';
import 'package:inspiry_learning/views/pages/common/setting/change_password_page.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _isLoading = false;
  bool _isUserRemoving = false;
  bool isAdmin = UserTypeHelper.isAdmin();

  var user = ActiveUser.instance.user;

  late TextEditingController _phoneController;
  late TextEditingController _lastNameController;
  late TextEditingController _passwordController;
  late TextEditingController _firstNameController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController(text: user?.phone);
    _lastNameController = TextEditingController(text: user?.lastname);
    _firstNameController = TextEditingController(text: user?.firstname);
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
                    AppStrings.accountSetting,
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
                      if (isAdmin && UserTypeHelper.isSuperAdmin())
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () => AppRouter.push(
                                  context,
                                  const AddAdminPage(
                                    adminType: AdminType.superAdmin,
                                    title: 'Add ${AppStrings.superAdmin}',
                                  ),
                                ),
                                child: Container(
                                  height: 48.h,
                                  width: ScreenSize.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(
                                      width: 2.w,
                                      color: AppColors.teal400,
                                    ),
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        maxRadius: 12.r,
                                        backgroundColor: AppColors.teal400,
                                        child: const Icon(
                                          Icons.add,
                                          color: AppColors.white,
                                          size: 18,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        AppStrings.superAdmin,
                                        style: AppStyle.textstylepoppinsmedium14
                                            .copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => AppRouter.push(
                                  context,
                                  const AddAdminPage(
                                    adminType: AdminType.subAdmin,
                                    title: 'Add ${AppStrings.subAdmin}',
                                  ),
                                ),
                                child: Container(
                                  height: 48.h,
                                  width: ScreenSize.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(
                                      width: 2.w,
                                      color: AppColors.teal400,
                                    ),
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        maxRadius: 12.r,
                                        backgroundColor: AppColors.teal400,
                                        child: const Icon(
                                          Icons.add,
                                          color: AppColors.white,
                                          size: 18,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        AppStrings.subAdmin,
                                        style: AppStyle.textstylepoppinsmedium14
                                            .copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Center(
                        child: Image.asset(
                          AppAssets.frame,
                          scale: 3.5,
                        ),
                      ),
                      Column(
                        children: [
                          _buildEditAbleTextFields(
                            text: AppStrings.firstName,
                            controller: _firstNameController,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 12.h),
                          _buildEditAbleTextFields(
                            text: AppStrings.lastName,
                            controller: _lastNameController,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 12.h),
                          _buildEditAbleTextFields(
                            text: AppStrings.phoneNumber,
                            icon: Icons.phone,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => AppRouter.push(
                          context,
                          const ChangePasswordPage(),
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          AppStrings.changePassword + AppStrings.questionMark,
                          style: AppStyle.textstylepoppinssemibold12.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      _isLoading
                          ? const CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.yellow701,
                              ),
                            )
                          : CustomButton(
                              AppStrings.save,
                              onPressed: () async =>
                                  await _saveBtnClickHandler(),
                            ),
                      _isUserRemoving
                          ? const CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.yellow701,
                              ),
                            )
                          : CustomButton(
                              AppStrings.deleteAccount,
                              color: AppColors.red300,
                              onPressed: () async {
                                final password = await _deleteBtnClickHandler();
                                if (password != null) {
                                  setState(() {
                                    _isUserRemoving = true;
                                  });
                                  final canRemove = await UserRepository()
                                      .removeUser(password: password);
                                  if (canRemove) {
                                    await AppUtils.removeTokenToBackend();
                                    await User.remove();
                                    AppRouter.makeFirst(
                                        context, const UserInfoPage());
                                  } else {
                                    setState(() {
                                      _isUserRemoving = false;
                                    });
                                  }
                                }
                              },
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

  Widget _buildEditAbleTextFields({
    required String text,
    String? initialValue,
    TextInputType? keyboardType,
    IconData icon = Icons.person,
    TextEditingController? controller,
  }) {
    return InputTextField(
      text,
      icon: Icon(icon),
      initialValue: initialValue,
      keyboardType: keyboardType,
      controller: controller,
    );
  }

  dynamic getControllers() => [
        _firstNameController,
        _lastNameController,
        _phoneController,
      ];

  Future<void> _saveBtnClickHandler() async {
    if (_isLoading) return;
    if (AppUtils.checkIsAnyFieldIsEmpty(controllers: getControllers())) {
      AppUtils.showToast(AppStrings.allFieldsAreRequired);
      return;
    }
    setState(() => _isLoading = true);
    user = user?.copyWith(
      firstname: _firstNameController.text,
      lastname: _lastNameController.text,
      phone: _phoneController.text,
    );
    if (user == null) {
      AppUtils.showToast(AppStrings.somethingWentWrong);
      setState(() => _isLoading = false);
      return;
    }
    ActiveUser.instance.user = await UserRepository().updateUser(user: user!);
    setState(() => _isLoading = false);
    if (ActiveUser.instance.user != null) {
      AppRouter.pop(context);
    }
  }

  Future<String?> _deleteBtnClickHandler() async {
    String? password;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 30.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputTextField(
                AppStrings.enterPassword,
                controller: _passwordController,
                keyboardType: TextInputType.name,
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              AppStrings.confirm,
              style: AppStyle.textstylepoppinsbold14
                  .copyWith(color: AppColors.white),
            ),
            color: AppColors.greenA700,
            onPressed: () {
              if (_passwordController.text.isNotEmpty) {
                password = _passwordController.text;
              }
              AppRouter.pop(context);
            },
          ),
        ],
      ),
    );
    return password;
  }
}
