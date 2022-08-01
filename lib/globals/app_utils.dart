import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/assignment_model.dart';

enum WorkStatus {
  compleated,
  inProgress,
  newRequest,
  underReview,
  pendingPayment,
}

class ScreenSize {
  static late double width;
  static late double height;
}

class ActiveUser {
  ActiveUser._();
  static final ActiveUser instance = ActiveUser._();
  User? user;
}

class Utils {
  static get role => UserTypeHelper.isAdmin() ? "admin" : "user";

  static Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  static Future<OpenResult> openFile(String path) async {
    return await OpenFile.open(path);
  }

  static String converBytes(int bytes) {
    double mb = bytes / 1024 / 1024;
    double kb = bytes / 1024;
    double b = bytes.toDouble();
    if (mb > 1) {
      return "${mb.round()} MB";
    } else if (kb > 1) {
      return "${kb.round()} KB";
    } else {
      return "${b.round()} B";
    }
  }

  static String fromatTime(DateTime dateTime) {
    if (dateTime.hour < 12) {
      return "${dateTime.hour}:${dateTime.minute} AM";
    } else if (dateTime.hour == 12) {
      return "${dateTime.hour}:${dateTime.minute} PM";
    } else {
      return "${dateTime.hour - 12}:${dateTime.minute} PM";
    }
  }

  static WorkStatus getWorkStatus(String status) {
    switch (status) {
      case "Work Completed":
        return WorkStatus.compleated;
      case "Work in Progress":
        return WorkStatus.inProgress;
      case "New Request":
        return WorkStatus.newRequest;
      case "Under Review":
        return WorkStatus.underReview;
      case "Pending Payment":
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
      case WorkStatus.newRequest:
        return "New Request";
      case WorkStatus.underReview:
        return "Under Review";
      case WorkStatus.pendingPayment:
        return "Pending Payment";
    }
  }

  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      fontSize: 16.0,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: AppColors.gray800,
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

  static bool checkIsAnyFieldIsEmpty(
      {required List<TextEditingController> controllers}) {
    for (final controller in controllers) {
      if (controller.text.isEmpty) {
        return true;
      }
    }
    return false;
  }

  static bool isPasswordMatched(
      {required List<TextEditingController> controllers}) {
    return controllers[0].text == controllers[1].text;
  }

  static void clearAllFields(
      {required List<TextEditingController> controllers}) {
    for (final controller in controllers) {
      controller.clear();
    }
  }
}
