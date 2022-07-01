import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/views/widgets/custom_card.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/repositories/assignment_repositories.dart';
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
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SafeArea(
            child: SizedBox(
              height: ScreenSize.height * 0.1,
              child: Padding(
                padding: EdgeInsets.only(top: 20.h, left: 22.w, right: 22.w),
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
                        SizedBox(width: 6.w),
                        Text(
                          (ActiveUser.instance.user?.firstname ??
                                  AppStrings.marley) +
                              AppStrings.exclamation,
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
                        SizedBox(width: 18.w),
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
          SizedBox(height: 12.h),
          Text(AppStrings.submittedFormList,
              style: AppStyle.textstylepoppinsmedium11),
          Expanded(
            child:

                // ActiveUser.userId == null
                //     ? const Center(child: Text(AppStrings.somethingWentWrong))
                //     :

                FutureBuilder(
              future: AssignmentRepository()
                  .getAssignments(ActiveUser.instance.user!.userId!),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final assignments = snapshot.data;
                  return ListView.builder(
                    itemCount: assignments.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => CustomCard(
                      assignment: assignments[index],
                      onPressed: () => AppRouter.push(
                        context,
                        ChatPage(assignment: assignments[index]),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(AppStrings.somethingWentWrong),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 36.h),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: ScreenSize.width * 0.82,
        child: Padding(
          padding: EdgeInsets.only(bottom: 3.h),
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
