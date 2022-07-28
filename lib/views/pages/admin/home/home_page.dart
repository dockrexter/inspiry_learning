import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_card.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/repositories/assignment_repositories.dart';
import 'package:inspiry_learning/views/pages/common/setting/account_setting_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Assignment>? assignments;
  DateTime _selectedDate = DateTime.now();
  static const _narrowWeekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  void initState() {
    super.initState();
    _getAssignments();
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
                      Image.asset(
                        AppAssets.bellIcon,
                        color: AppColors.white,
                        scale: 4,
                      ),
                      SizedBox(width: 18.w),
                      InkWell(
                        onTap: () {
                          AppRouter.push(context, const AccountSettingsPage());
                        },
                        child: Image.asset(
                          AppAssets.settingIcon,
                          color: AppColors.white,
                          scale: 4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          assignments == null
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Expanded(
                  child: RefreshIndicator(
                    displacement: 10.h,
                    onRefresh: () => _getAssignments(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildCalendar(),
                          _buildAssignments(),
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

  Widget _buildAssignments() {
    final filteredAssignments = assignments!
        .where((e) => Utils.compare2Dates(e.deadline!, _selectedDate))
        .toList();
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
        firstDay: DateTime(now.year, now.month, 1),
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
