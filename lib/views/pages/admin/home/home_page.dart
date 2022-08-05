import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_card.dart';
import 'package:inspiry_learning/views/widgets/custom_notifications_popup.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/views/pages/common/user_info_page.dart';
import 'package:inspiry_learning/repositories/assignment_repositories.dart';
import 'package:inspiry_learning/views/pages/common/setting/account_setting_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  DateTime _selectedDate = DateTime.now();
  List<Assignment>? assignments, otherDueAssignments;
  static const _narrowWeekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  void initState() {
    super.initState();
    _getAssignments();
    _getOtherDueAssignments();
  }

  @override
  Widget build(BuildContext context) {
    final height = ScreenSize.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
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
                        onTap: () => customNotificationsPopup(context),
                        child: Image.asset(
                          AppAssets.bellIcon,
                          color: AppColors.white,
                          scale: 4,
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
                        onTap: () async {
                          await User.remove();
                          AppRouter.makeFirst(context, const UserInfoPage());
                        },
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
                          month: _selectedDate.month.toString(),
                          year: _selectedDate.year.toString());
                      if (Utils.compare2Dates(_selectedDate, DateTime.now())) {
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
    );
  }

  Future<void> _getAssignments({String? month, String? year}) async {
    assignments = await AssignmentRepository().getAssignmentsByMonth(
        month ?? DateTime.now().month.toString(),
        year ?? DateTime.now().year.toString());
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
                    onSelected: (String status) async {
                      var assignment = assignments![Utils.findIndexByID(
                          assignments, filteredAssignments[index - 1].id)];
                      await AssignmentRepository()
                          .updateAssignmentStatus(assignment.id, status);
                      assignment.status = Utils.getWorkStatus(status);
                      setState(() {});
                    },
                    onPressed: () => AppRouter.push(
                      context,
                      ChatPage(assignment: filteredAssignments[index - 1]),
                    ),
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
                  onSelected: (String status) async {
                    var assignment = assignments![Utils.findIndexByID(
                        assignments,
                        otherDueAssignments![
                                index - filteredAssignments.length - 2]
                            .id)];
                    await AssignmentRepository()
                        .updateAssignmentStatus(assignment.id, status);
                    assignment.status = Utils.getWorkStatus(status);
                    setState(() {});
                  },
                  onPressed: () => AppRouter.push(
                    context,
                    ChatPage(
                        assignment: otherDueAssignments![
                            index - filteredAssignments.length - 2]),
                  ),
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
        onSelected: (String status) async {
          var assignment = assignments![
              Utils.findIndexByID(assignments, filteredAssignments[index].id)];
          await AssignmentRepository()
              .updateAssignmentStatus(assignment.id, status);
          assignment.status = Utils.getWorkStatus(status);
          setState(() {});
        },
        onPressed: () => AppRouter.push(
          context,
          ChatPage(assignment: filteredAssignments[index]),
        ),
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
          weekdayStyle: AppStyle.textstylepoppinsbold14,
          weekendStyle: AppStyle.textstylepoppinsbold14,
        ),
        onPageChanged: (dt) {
          if (dt.month == now.month && dt.year == now.year) {
            _selectedDate = now;
          } else {
            _selectedDate = dt;
          }

          _getAssignments(month: dt.month.toString(), year: dt.year.toString());
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
}
