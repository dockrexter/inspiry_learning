import 'dart:typed_data';

import 'package:inspiry_learning/globals/app_utils.dart';

class Assignment {
  int id;
  int? userId;
  WorkStatus status;
  String? subject, summary;
  List<Uint8List?>? attachments;
  DateTime? createdDate, deadline;

  Assignment({
    required this.id,
    this.userId,
    this.subject,
    this.summary,
    this.deadline,
    this.createdDate,
    this.attachments,
    this.status = WorkStatus.newRequest,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      subject: json['subject'] as String?,
      summary: json['summary'] as String?,
      status: Utils.getWorkStatus(json['status']),
      deadline: DateTime.parse(json['deadline']),
      createdDate: DateTime.parse(json['created_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'subject': subject ?? '',
      'summary': summary ?? '',
      'attachments': [], // attachments,
      'status': Utils.getStatus(status),
      'deadline': deadline?.toIso8601String(),
      'created_date': (createdDate ?? DateTime.now()).toIso8601String(),
    };
  }
}
