import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/app_assets.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_card.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/views/pages/common/setting/account_setting_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Assignment> assignments = Utils.getAssignments();
  DateTime _selectedDate = DateTime.now();
  static const _narrowWeekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final filteredAssignments =
        Utils.compare2Dates(DateTime.now(), _selectedDate)
            ? assignments
            : assignments
                .where((e) => Utils.compare2Dates(e.dueDate!, _selectedDate))
                .toList();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            height: height * 0.16,
            color: AppColors.teal400,
            padding: const EdgeInsets.only(top: 12.0, left: 22.0, right: 22.0),
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
                      const SizedBox(width: 6),
                      Text(
                        AppStrings.marley,
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
                      const SizedBox(width: 18),
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
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.black.withOpacity(0.08),
          ),
          Expanded(
            child: RefreshIndicator(
              displacement: 10,
              onRefresh: () {
                assignments = Utils.getAssignments();
                setState(() {});
                return Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCalendar(),
                    _buildAssignments(filteredAssignments),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignments(dynamic filteredAssignments) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredAssignments.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => CustomCard2(
        assignment: filteredAssignments[index],
        onSelected: (String status) {
          assignments[Utils.findIndexByID(
                  assignments, filteredAssignments[index].id)]
              .workStatus = Utils.getWorkStatus(status);
          setState(
            () {},
          );
        },
        onPressed: () => AppRouter.push(context, const ChatPage()),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12.0),
      decoration: const BoxDecoration(
        color: AppColors.teal400,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        currentDay: DateTime.now(),
        focusedDay: _selectedDate,
        lastDay: DateTime.now().add(const Duration(days: 365)),
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: AppColors.yellow701,
          ),
          selectedTextStyle: AppStyle.textstylepoppinsmedium12.copyWith(
            fontSize: 14,
            color: AppColors.black,
          ),
          todayDecoration: BoxDecoration(
            border: Border.all(
              color: AppColors.yellow701,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5),
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
              horizontal: MediaQuery.of(context).size.width * 0.1),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppColors.white,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppColors.white,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (dt, _) =>
              _narrowWeekdays[dt.weekday == 7 ? 0 : dt.weekday],
          weekdayStyle: AppStyle.textstylepoppinsbold14,
          weekendStyle: AppStyle.textstylepoppinsbold14,
        ),
        onDaySelected: (dt, _) => setState(() => _selectedDate = dt),
        holidayPredicate: (dt) => Utils.selectedDates(assignments, dt),
        selectedDayPredicate: (dt) => Utils.compare2Dates(dt, _selectedDate),
      ),
    );
  }
}
