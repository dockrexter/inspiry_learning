import 'package:inspiry_learning/globals/utils.dart';

class Assignment {
  bool isChecked;
  WorkStatus workStatus;
  String? startDate, dueDate, title;

  Assignment({
    this.title,
    this.dueDate,
    this.startDate,
    this.isChecked = false,
    this.workStatus = WorkStatus.inProgress,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      title: json['title'] as String?,
      dueDate: json['dueDate'] as String?,
      startDate: json['startDate'] as String?,
      isChecked: json['isChecked'] as bool,
      workStatus: WorkStatus.values[json['workStatus']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dueDate': dueDate,
      'startDate': startDate,
      'isChecked': isChecked,
      'workStatus': workStatus.index,
    };
  }
}

List<Assignment> getAssingments() {
  return [
    Assignment(
      dueDate: "10-6-22",
      startDate: "2-6-22",
      title: "History of Graphic Design",
    ),
    Assignment(
      isChecked: true,
      dueDate: "10-6-22",
      startDate: "2-6-22",
      title: "Art and Culture",
      workStatus: WorkStatus.compleated,
    ),
    Assignment(
      dueDate: "10-6-22",
      startDate: "2-6-22",
      title: "Information Design",
    ),
    Assignment(
      isChecked: true,
      dueDate: "10-6-22",
      startDate: "2-6-22",
      title: "Food Sciences",
      workStatus: WorkStatus.pendingPayment,
    ),
    Assignment(
      isChecked: true,
      dueDate: "10-6-22",
      startDate: "2-6-22",
      title: "Infrastructure Studies",
      workStatus: WorkStatus.pendingPayment,
    ),
    // Duplicated
    Assignment(
      dueDate: "10-6-22",
      startDate: "2-6-22",
      title: "History of Graphic Design",
    ),
    Assignment(
      isChecked: true,
      dueDate: "10-6-22",
      startDate: "2-6-22",
      title: "Art and Culture",
      workStatus: WorkStatus.compleated,
    ),
    Assignment(
      dueDate: "10-6-22",
      startDate: "2-6-22",
      title: "Information Design",
    ),
    Assignment(
      isChecked: true,
      dueDate: "10-6-22",
      startDate: "2-6-22",
      title: "Food Sciences",
      workStatus: WorkStatus.pendingPayment,
    ),
    Assignment(
      isChecked: true,
      dueDate: "10-6-22",
      startDate: "2-6-22",
      title: "Infrastructure Studies",
      workStatus: WorkStatus.pendingPayment,
    ),
  ];
}
