import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/models/attachment_model.dart';

class Assignment {
  int id;
  int? userId;
  String? assignTo;
  WorkStatus status;
  String? subject, summary;
  List<Attachment>? attachments;
  DateTime? createdDate, deadline;

  Assignment({
    required this.id,
    this.userId,
    this.subject,
    this.summary,
    this.deadline,
    this.assignTo,
    this.createdDate,
    this.attachments,
    this.status = WorkStatus.newRequest,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as int,
      userId: json['user_id'] as int?,
      subject: json['subject'] as String?,
      summary: json['summary'] as String?,
      assignTo: json['assignee'] as String?,
      status: Utils.getWorkStatus(json['status']),
      deadline: DateTime.parse(json['deadline']),
      createdDate: DateTime.parse(json['created_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId.toString(),
      'subject': subject ?? '',
      'summary': summary ?? '',
      'assignee': assignTo ?? '',
      'attachments': attachments,
      'status': Utils.getStatus(status),
      'deadline': deadline?.toIso8601String(),
      'created_date': (createdDate ?? DateTime.now()).toIso8601String(),
    };
  }
}
