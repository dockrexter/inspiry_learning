import 'package:inspiry_learning/globals/utils.dart';

class Assignment {
  int id;
  String? title;
  WorkStatus workStatus;
  DateTime? startDate, dueDate;

  Assignment({
    required this.id,
    this.title,
    this.dueDate,
    this.startDate,
    this.workStatus = WorkStatus.inProgress,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as int,
      title: json['title'] as String?,
      dueDate: DateTime.parse(json['dueDate']),
      startDate: DateTime.parse(json['startDate']),
      workStatus: WorkStatus.values[json['workStatus']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'workStatus': workStatus.index,
      'dueDate': dueDate!.millisecondsSinceEpoch,
      'startDate': startDate!.millisecondsSinceEpoch,
    };
  }
}
