import 'dart:math';
import 'package:inspiry_learning/models/assignment_model.dart';

enum WorkStatus {
  compleated,
  inProgress,
  pendingPayment,
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

  static bool compare2Dates(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  static List<DateTime> getAssignmentDueDates(List<Assignment> assignments) {
    final dueDates = <DateTime>[];
    for (final assignment in assignments) {
      dueDates.add(assignment.dueDate!);
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

  static List<Assignment> getAssignments() {
    final random = Random();
    return [
      Assignment(
        id: 1,
        dueDate: DateTime.parse("2022-06-10"),
        startDate: DateTime.parse("2022-06-02"),
        title: "History of Graphic Design",
      ),
      Assignment(
        id: 2,
        dueDate: DateTime.parse("2022-06-10"),
        startDate: DateTime.parse("2022-06-02"),
        title: "Art and Culture",
        workStatus: WorkStatus.compleated,
      ),
      Assignment(
        id: 3,
        dueDate: DateTime.parse("2022-06-10"),
        startDate: DateTime.parse("2022-06-02"),
        title: "Information Design",
      ),
      Assignment(
        id: 4,
        dueDate: DateTime.parse("2022-06-10"),
        startDate: DateTime.parse("2022-06-02"),
        title: "Food Sciences",
        workStatus: WorkStatus.pendingPayment,
      ),
      Assignment(
        id: 5,
        dueDate: DateTime.parse("2022-06-10"),
        startDate: DateTime.parse("2022-06-02"),
        title: "Infrastructure Studies",
        workStatus: WorkStatus.pendingPayment,
      ),
      // Duplicated assignment
      Assignment(
        id: 101,
        dueDate: DateTime.parse("2022-07-05"),
        startDate: DateTime.parse("2022-06-02"),
        title: "Food Sciences",
        workStatus: WorkStatus.compleated,
      ),
      Assignment(
        id: 102,
        dueDate: DateTime.parse("2022-08-12"),
        startDate: DateTime.parse("2022-06-02"),
        title: "Infrastructure Studies",
        workStatus: WorkStatus.pendingPayment,
      ),
      Assignment(
        id: 103,
        dueDate: DateTime.parse("2022-06-08"),
        startDate: DateTime.parse("2022-06-02"),
        title: "Art and Culture",
        workStatus: WorkStatus.pendingPayment,
      ),
      for (int i = 6; i < 101; i++)
        Assignment(
          id: i,
          dueDate: DateTime.parse(
              "2022-06-${["10", "13", "23", "30"][random.nextInt(4)]}"),
          startDate: DateTime.parse("2022-06-02"),
          title: [
            "History of Graphic Design",
            "Art and Culture",
            "Information Design",
            "Food Sciences",
            "Infrastructure Studies"
          ][random.nextInt(5)],
          workStatus: WorkStatus.values[random.nextInt(3)],
        ),
    ];
  }
}
