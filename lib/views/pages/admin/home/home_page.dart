import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_card.dart';
import 'package:inspiry_learning/models/all_notification_model.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/repositories/allnotification_repo.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';
import 'package:inspiry_learning/repositories/assignment_repositories.dart';
import 'package:inspiry_learning/views/widgets/custom_notifications_popup.dart';
import 'package:inspiry_learning/views/pages/common/setting/account_setting_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  List<AllNotificationData>? allnotification;
  List<Assignment>? assignments, otherDueAssignments;
  final _assigneeController = TextEditingController();
  final Box _countBox = Hive.box('notificationcounter');

  static const _narrowWeekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  void initState() {
    super.initState();
    Utils.addTokenToBackend();
    _getAssignments();
    _getOtherDueAssignments();
  }

  @override
  void dispose() {
    _assigneeController.dispose();
    super.dispose();
  }

  Future<void> _getAllNotification() async {
    allnotification = await AllNotifactionRepository().getallNotification();
    setState(() {});
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });
    await Utils.removeTokenToBackend();
    await User.remove();
    AppRouter.makeFirst(context, const UserInfoPage());
  }

  Widget notificationCounter() {
    return ValueListenableBuilder<Box>(
        valueListenable: _countBox.listenable(),
        builder: (context, box, widget) {
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
    final height = ScreenSize.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          Opacity(
            opacity: _isLoading ? 0.35 : 1.0,
            child: Column(
              children: [
                Container(
                  height: height * 0.16,
                  color: AppColors.teal400,
                  padding: EdgeInsets.only(top: 12.h, left: 22.w, right: 22.w),
                  child: SafeArea(
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
                                color: AppColors.white,
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
                                position:
                                    BadgePosition.topEnd(top: -5, end: -5),
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                animationType: BadgeAnimationType.slide,
                                badgeContent: notificationCounter(),
                                child: const Icon(
                                  Icons.notifications,
                                  size: 26,
                                ),
                              ),
                            ),
                            SizedBox(width: 18.w),
                            InkWell(
                              onTap: () => AppRouter.push(
                                  context, const AccountSettingsPage()),
                              child: Image.asset(
                                AppAssets.settingIcon,
                                color: AppColors.white,
                                scale: 4,
                              ),
                            ),
                            SizedBox(width: 18.w),
                            InkWell(
                              onTap: () async => await showDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: const Text("logout"),
                                  content: const Text("Please Confirm Logout"),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text("Yes"),
                                      onPressed: () {
                                        _handleLogout();
                                        AppRouter.pop(context);
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text("No"),
                                      onPressed: () => AppRouter.pop(context),
                                    ),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: assignments == null
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : RefreshIndicator(
                          displacement: 10.h,
                          onRefresh: () async {
                            await _getAssignments(
                                month: _selectedDate.month,
                                year: _selectedDate.year);
                            if (Utils.compare2Dates(
                                _selectedDate, DateTime.now())) {
                              await _getOtherDueAssignments();
                            }
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                _buildCalendar(),
                                _buildAssignments(),
                                SizedBox(height: 80.h),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getAssignments({int? month, int? year}) async {
    assignments = await AssignmentRepository().getAssignmentsByMonth(
        month ?? DateTime.now().month, year ?? DateTime.now().year);
    setState(() {});
  }

  Future<void> _getOtherDueAssignments() async {
    otherDueAssignments = await AssignmentRepository().getAllDueAssignments();
    setState(() {});
  }

  Widget _buildAssignments() {
    final filteredAssignments = assignments!
        .where((e) => Utils.compare2Dates(e.deadline!, _selectedDate))
        .toList();

    if (Utils.compare2Dates(_selectedDate, DateTime.now())) {
      return otherDueAssignments == null
          ? Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow701)),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount:
                  filteredAssignments.length + otherDueAssignments!.length + 2,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return filteredAssignments.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(bottom: 20.h, left: 22.w),
                          child: Text(
                            AppStrings.dueToday,
                            style: AppStyle.textstylepoppinsbold17.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        );
                } else if (index <= filteredAssignments.length) {
                  return CustomCard2(
                    assignment: filteredAssignments[index - 1],
                    updateAssignee: (id, assignTo) async {
                      await _updateAssignee(id, assignTo);
                      await _getAssignments();
                      await _getOtherDueAssignments();
                      setState(() {});
                    },
                    onSelected: (int status) async {
                      var assignment = assignments![Utils.findIndexByID(
                          assignments, filteredAssignments[index - 1].id)];
                      await AssignmentRepository()
                          .updateAssignmentStatus(assignment.id, status);
                      assignment.status = WorkStatus.values[status];
                      setState(() {});
                    },
                    onPressed: () async {
                      await AppRouter.push(
                        context,
                        ChatPage(assignment: filteredAssignments[index - 1]),
                      );
                      await _getAssignments();
                      await _getOtherDueAssignments();
                      setState(() {});
                    },
                  );
                } else if (index == filteredAssignments.length + 1) {
                  return otherDueAssignments!.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(bottom: 20.h, left: 22.w),
                          child: Text(
                            AppStrings.allDueAssignments,
                            style: AppStyle.textstylepoppinsbold17.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        );
                }
                return CustomCard2(
                  assignment: otherDueAssignments![
                      index - filteredAssignments.length - 2],
                  updateAssignee: (id, assignTo) async {
                    await _updateAssignee(id, assignTo);
                    await _getAssignments();
                    await _getOtherDueAssignments();
                    setState(() {});
                  },
                  onSelected: (int status) async {
                    var assignment = assignments![Utils.findIndexByID(
                        assignments,
                        otherDueAssignments![
                                index - filteredAssignments.length - 2]
                            .id)];
                    await AssignmentRepository()
                        .updateAssignmentStatus(assignment.id, status);
                    assignment.status = WorkStatus.values[status];
                    setState(() {});
                  },
                  onPressed: () async {
                    await AppRouter.push(
                      context,
                      ChatPage(
                          assignment: otherDueAssignments![
                              index - filteredAssignments.length - 2]),
                    );
                    await _getAssignments();
                    await _getOtherDueAssignments();
                    setState(() {});
                  },
                );
              },
            );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredAssignments.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => CustomCard2(
        assignment: filteredAssignments[index],
        updateAssignee: (id, assignTo) async {
          await _updateAssignee(id, assignTo);
          await _getAssignments();
          await _getOtherDueAssignments();
          setState(() {});
        },
        onSelected: (int status) async {
          var assignment = assignments![
              Utils.findIndexByID(assignments, filteredAssignments[index].id)];
          await AssignmentRepository()
              .updateAssignmentStatus(assignment.id, status);
          assignment.status = WorkStatus.values[status];
          setState(() {});
        },
        onPressed: () async {
          await AppRouter.push(
            context,
            ChatPage(assignment: filteredAssignments[index]),
          );
          await _getAssignments();
          await _getOtherDueAssignments();
          setState(() {});
        },
      ),
    );
  }

  Widget _buildCalendar() {
    final now = DateTime.now();
    return Container(
      padding: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.teal400,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: TableCalendar(
        currentDay: now,
        lastDay: DateTime(2037),
        focusedDay: _selectedDate,
        firstDay: DateTime(now.year, 1, 1),
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: AppColors.yellow701,
          ),
          selectedTextStyle: AppStyle.textstylepoppinsmedium12.copyWith(
            fontSize: 14.sp,
            color: AppColors.black,
          ),
          todayDecoration: BoxDecoration(
            border: Border.all(
              color: AppColors.yellow701,
              width: 2.w,
            ),
            borderRadius: BorderRadius.circular(5.r),
          ),
          holidayDecoration: const BoxDecoration(
            color: AppColors.red300,
            shape: BoxShape.circle,
          ),
          outsideDaysVisible: false,
          holidayTextStyle: AppStyle.textstylepoppinsmedium12,
          defaultTextStyle: AppStyle.textstylepoppinsmedium12,
          weekendTextStyle: AppStyle.textstylepoppinsmedium12,
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: AppStyle.textstylepoppinsmedium18,
          formatButtonVisible: false,
          titleCentered: true,
          headerPadding: EdgeInsets.symmetric(
              horizontal: ScreenSize.width * 0.1, vertical: 8.h),
          leftChevronIcon: _buildIcons(Icons.chevron_left),
          rightChevronIcon: _buildIcons(Icons.chevron_right),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (dt, _) =>
              _narrowWeekdays[dt.weekday == 7 ? 0 : dt.weekday],
          weekdayStyle: AppStyle.textstylepoppinsbold14.copyWith(fontSize: 13),
          weekendStyle: AppStyle.textstylepoppinsbold14.copyWith(fontSize: 13),
        ),
        onPageChanged: (dt) {
          if (dt.month == now.month && dt.year == now.year) {
            _selectedDate = now;
          } else {
            _selectedDate = dt;
          }

          _getAssignments(month: dt.month, year: dt.year);
        },
        onDaySelected: (dt, _) => setState(() => _selectedDate = dt),
        holidayPredicate: (dt) => Utils.selectedDates(assignments!, dt),
        selectedDayPredicate: (dt) => Utils.compare2Dates(dt, _selectedDate),
      ),
    );
  }

  Widget _buildIcons(IconData icon) {
    return Container(
      width: 20.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Icon(
        icon,
        size: 20,
        color: AppColors.teal400,
      ),
    );
  }

  Future<void> _updateAssignee(int? assignmentId, String? assignTo) async {
    if (assignmentId == null) return;
    _assigneeController.text = assignTo ?? AppStrings.marley;
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: SizedBox(
          width: 30.w,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            InputTextField(
              "",
              controller: _assigneeController,
              keyboardType: TextInputType.name,
            ),
          ]),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              AppStrings.done,
              style: AppStyle.textstylepoppinsbold14
                  .copyWith(color: AppColors.greenA700),
            ),
            onPressed: () async {
              if (_assigneeController.text.isNotEmpty) {
                await AssignmentRepository()
                    .updateAssignee(assignmentId, _assigneeController.text);
              }
              AppRouter.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
