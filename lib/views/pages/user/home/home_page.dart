import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/utils.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/assets_path.dart';
import 'package:inspiry_learning/views/widgets/custom_card.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/views/pages/common/setting/account_setting_page.dart';
import 'package:inspiry_learning/views/pages/user/submission/assignment_submission_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final assignments = Utils.getAssignments();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 22.0, right: 22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppStrings.hello,
                          style: AppStyle.textstylepoppinsbold24.copyWith(
                            color: AppColors.yellow701,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppStrings.marley,
                          style: AppStyle.textstylepoppinsbold24.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.bellIcon,
                          scale: 4,
                        ),
                        const SizedBox(width: 18),
                        InkWell(
                          onTap: () {
                            AppRouter.push(
                                context, const AccountSettingsPage());
                          },
                          child: Image.asset(
                            AppAssets.settingIcon,
                            scale: 4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: AppColors.black.withOpacity(0.08),
            thickness: 1,
          ),
          const SizedBox(height: 12),
          Text(AppStrings.submittedFormList,
              style: AppStyle.textstylepoppinsmedium11),
          Expanded(
            child: ListView.builder(
              itemCount: assignments.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => CustomCard(
                assignment: assignments[index],
                onPressed: () => AppRouter.push(context, const ChatPage()),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.82,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: CustomButton(
            AppStrings.submitNewAssignmentForm,
            outlineBoarder: true,
            onPressed: () =>
                AppRouter.push(context, const AssignmentFormSubmissionPage()),
          ),
        ),
      ),
    );
  }
}
