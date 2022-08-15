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

  // {id: 1, userId: 1, subject: Data Mining, summary: Hi Please Solve This Assignment ASAP, assignee: null, status: 0, deadline: 2022-08-12 07:49:20.986Z, paymentStatus: 0, createdAt: 2022-08-12T11:46:36.237Z, updatedAt: 2022-08-12T12:50:49.335Z}

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
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
