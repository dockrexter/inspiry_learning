import 'package:inspiry_learning/globals/app_utils.dart';

class Assignment {
  int id;
  WorkStatus status;
  String? subject, summary;
  List<List<int>>? attachments;
  DateTime? createdDate, deadline;

  Assignment({
    required this.id,
    this.subject,
    this.summary,
    this.deadline,
    this.createdDate,
    this.status = WorkStatus.inProgress,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as int,
      subject: json['subject'] as String?,
      summary: json['summary'] as String?,
      status: WorkStatus.values[json['status']],
      deadline: DateTime.parse(json['deadline']),
      createdDate: DateTime.parse(json['created_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'summary': summary,
      'status': status.index,
      'attachments': attachments,
      'deadline': deadline!.millisecondsSinceEpoch,
      'created_date': createdDate!.millisecondsSinceEpoch,
    };
  }
}
