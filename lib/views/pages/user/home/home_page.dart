import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/all_notification_model.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:inspiry_learning/repositories/allnotification_repo.dart';
import 'package:inspiry_learning/repositories/assignment_repositories.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/views/pages/common/setting/account_setting_page.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';
import 'package:inspiry_learning/views/pages/user/submission/assignment_submission_form.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/widgets/custom_card.dart';

import '../../../widgets/custom_notifications_popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ChangeNotifier {
  List<Assignment>? assignments;
  List<AllNotificationData>? allnotification;
  String? assignmentid;
  final Box _countBox = Hive.box('notificationcounter');

  @override
  void initState() {
    super.initState();
    _getAssignments();
    _getAllNotification();
    // Utils.addTokenToBackend();
  }

  Future<void> _getAllNotification() async {
    allnotification = await AllNotifactionRepository().getallNotification();
    setState(() {});
  }

  Future<void> _getAssignments() async {
    assignments = await AssignmentRepository()
        .getAssignments(ActiveUser.instance.user!.userId!);
    setState(() {});
  }

  Widget notificationCounter() {
    return ValueListenableBuilder<Box>(
        valueListenable: _countBox.listenable(),
        builder: (context, box, widget) {
          print({box.get('count', defaultValue: 0)});
          return box.get("count", defaultValue: 0) <= 1
              ? Container()
              : Text(
                  '${box.get('count', defaultValue: 0)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                  ),
                );
        });
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
                        InkWell(
                          onTap: () async {
                            await _getAllNotification();
                            customNotificationsPopup(context,
                                allnotification: allnotification);
                          },
                          child: Badge(
                            position: BadgePosition.topEnd(top: -5, end: -5),
                            animationDuration:
                                const Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.slide,
                            badgeContent: notificationCounter(),
                            child: const Icon(
                              Icons.notifications,
                              size: 26,
                            ),
                          ),
                          // child: Image.asset(
                          //   AppAssets.bellIcon,
                          //   scale: 4,
                          // ),
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
                            await Utils.removeTokenToBackend();
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
              onRefresh: () async {
                await _getAssignments();
                await _getAllNotification();
              },
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
              await AppRouter.push(
                  context, const AssignmentFormSubmissionPage());
              await _getAssignments();
            },
          ),
        ),
      ),
    );
  }
}
