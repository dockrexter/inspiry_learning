import 'package:flutter/material.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_card.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';
import 'package:inspiry_learning/repositories/assignment_repositories.dart';
import 'package:inspiry_learning/views/pages/common/setting/account_setting_page.dart';
import 'package:inspiry_learning/views/pages/user/submission/assignment_submission_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Assignment>? assignments;

  @override
  void initState() {
    super.initState();
    _getAssignments();
  }

  Future<void> _getAssignments() async {
    assignments = await AssignmentRepository()
        .getAssignments(ActiveUser.instance.user!.userId!);
    setState(() {});
  }

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
                        SizedBox(width: 18.w),
                        InkWell(
                          onTap: () async {
                            await User.remove();
                            AppRouter.makeFirst(context, const UserInfoPage());
                          },
                          child: const Icon(
                            Icons.logout,
                            color: AppColors.black,
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
            child: RefreshIndicator(
              displacement: 10.h,
              onRefresh: () async => await _getAssignments(),
              child: assignments == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: assignments!.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) => CustomCard(
                        assignment: assignments![index],
                        onPressed: () => AppRouter.push(
                          context,
                          ChatPage(assignment: assignments![index]),
                        ),
                      ),
                    ),
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
            onPressed: () async {
              await AppRouter.push(context, const AssignmentFormSubmissionPage());
              await _getAssignments();
            },
          ),
        ),
      ),
    );
  }
}
