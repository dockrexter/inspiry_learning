import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/models/attachment_model.dart';

class AssignmentDetail {
  int id;
  int? userId;
  String? assignTo;
  WorkStatus status;
  String? subject, summary;
  List<Attachment>? attachments;
  DateTime? createdDate, deadline;

  AssignmentDetail({
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

  factory AssignmentDetail.fromJson(Map<String, dynamic> json) {
    return AssignmentDetail(
      id: json['id'] as int,
      userId: json['userId'] as int?,
      subject: json['subject'] as String?,
      summary: json['summary'] as String?,
      assignTo: json['assignee'] as String?,
      deadline: DateTime.parse(json['deadline']),
      createdDate: DateTime.parse(json['createdAt']),
      status: WorkStatus.values[json['status'] as int],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'assignee': assignTo,
      'status': status.index,
      'subject': subject ?? '',
      'summary': summary ?? '',
      'attachments': attachments,
      'deadline': deadline?.toIso8601String(),
      'createdAt': (createdDate ?? DateTime.now()).toIso8601String(),
    };
  }
}
