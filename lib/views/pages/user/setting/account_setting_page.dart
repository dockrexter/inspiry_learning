import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/assets_path.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/user/setting/change_password_page.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
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
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                            initialValue: "Usama",
                          ),
                          const SizedBox(height: 12),
                          _buildEditAbleTextFields(
                            text: AppStrings.lastName,
                            initialValue: "Azad",
                          ),
                          const SizedBox(height: 12),
                          _buildEditAbleTextFields(
                            text: AppStrings.phoneNumber,
                            icon: Icons.phone,
                            initialValue: "+923465979647",
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
                      CustomButton(
                        AppStrings.save,
                        onPressed: () {},
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

  Row _buildEditAbleTextFields({
    required String text,
    String? initialValue,
    VoidCallback? onPressed,
    IconData icon = Icons.person,
    TextEditingController? controller,
  }) {
    return Row(
      children: [
        Expanded(
          child: InputTextField(
            text,
            enabled: false,
            icon: Icon(icon),
            initialValue: initialValue,
            controller: controller,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.drive_file_rename_outline_sharp,
          ),
        ),
      ],
    );
  }
}
