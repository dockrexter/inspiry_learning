import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inspiry_learning/models/assignment_model.dart';

enum WorkStatus {
  compleated,
  inProgress,
  pendingPayment,
}

class ScreenSize {
  static late double width;
  static late double height;
}

class Utils {
  static WorkStatus getWorkStatus(String status) {
    switch (status) {
      case 'Work Completed':
        return WorkStatus.compleated;
      case 'Work in Progress':
        return WorkStatus.inProgress;
      case 'Pending Payment':
        return WorkStatus.pendingPayment;
      default:
        return WorkStatus.inProgress;
    }
  }

  static String getStatus(WorkStatus status) {
    switch (status) {
      case WorkStatus.compleated:
        return "Work Completed";
      case WorkStatus.inProgress:
        return "Work in progress";
      case WorkStatus.pendingPayment:
        return "Pending Payment";
    }
  }

  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      fontSize: 16.0,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static bool compare2Dates(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  static List<DateTime> getAssignmentDueDates(List<Assignment> assignments) {
    final dueDates = <DateTime>[];
    for (final assignment in assignments) {
      dueDates.add(assignment.deadline!);
    }
    return dueDates;
  }

  static bool selectedDates(List<Assignment> assignments, DateTime date) {
    return getAssignmentDueDates(assignments)
        .map((dt) => compare2Dates(dt, date))
        .toList()
        .contains(true);
  }

  static convertDateToString(DateTime date) {
    return "${date.day}-${date.month}-${date.year.toString().substring(2)}";
  }

  static int findIndexByID(dynamic list, int id) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        return i;
      }
    }
    return -1;
  }

  static bool checkIsAnyFieldIsEmpty({required List<TextEditingController> controllers}) {
    for (final controller in controllers) {
      if (controller.text.isEmpty) {
        return true;
      }
    }
    return false;
  }

  static bool isPasswordMatched({required List<TextEditingController> controllers}) {
    return controllers[0].text == controllers[1].text;
  }

  static void clearAllFields({required List<TextEditingController> controllers}){
    for (final controller in controllers) {
      controller.clear();
    }
  }

  static List<Assignment> getAssignments() {
    final random = Random();
    return [
      Assignment(
        id: 1,
        deadline: DateTime.parse("2022-06-10"),
        createdDate: DateTime.parse("2022-06-02"),
        subject: "History of Graphic Design",
      ),
      Assignment(
        id: 2,
        deadline: DateTime.parse("2022-06-10"),
        createdDate: DateTime.parse("2022-06-02"),
        subject: "Art and Culture",
        status: WorkStatus.compleated,
      ),
      Assignment(
        id: 3,
        deadline: DateTime.parse("2022-06-10"),
        createdDate: DateTime.parse("2022-06-02"),
        subject: "Information Design",
      ),
      Assignment(
        id: 4,
        deadline: DateTime.parse("2022-06-10"),
        createdDate: DateTime.parse("2022-06-02"),
        subject: "Food Sciences",
        status: WorkStatus.pendingPayment,
      ),
      Assignment(
        id: 5,
        deadline: DateTime.parse("2022-06-10"),
        createdDate: DateTime.parse("2022-06-02"),
        subject: "Infrastructure Studies",
        status: WorkStatus.pendingPayment,
      ),
      // Duplicated assignment
      Assignment(
        id: 101,
        deadline: DateTime.parse("2022-07-05"),
        createdDate: DateTime.parse("2022-06-02"),
        subject: "Food Sciences",
        status: WorkStatus.compleated,
      ),
      Assignment(
        id: 102,
        deadline: DateTime.parse("2022-08-12"),
        createdDate: DateTime.parse("2022-06-02"),
        subject: "Infrastructure Studies",
        status: WorkStatus.pendingPayment,
      ),
      Assignment(
        id: 103,
        deadline: DateTime.parse("2022-06-08"),
        createdDate: DateTime.parse("2022-06-02"),
        subject: "Art and Culture",
        status: WorkStatus.pendingPayment,
      ),
      for (int i = 6; i < 101; i++)
        Assignment(
          id: i,
          deadline: DateTime.parse(
              "2022-06-${["10", "12", "13", "23", "30"][random.nextInt(5)]}"),
          createdDate: DateTime.parse("2022-06-02"),
          subject: [
            "History of Graphic Design",
            "Art and Culture",
            "Information Design",
            "Food Sciences",
            "Infrastructure Studies"
          ][random.nextInt(5)],
          status: WorkStatus.values[random.nextInt(3)],
        ),
    ];
  }
}
