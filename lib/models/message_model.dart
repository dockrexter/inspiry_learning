import 'package:inspiry_learning/models/attachment_model.dart';

class Message {
  int id;
  bool isMe;
  int assignmentId;
  String? message;
  DateTime? timeStamp;
  String? linktext, linkUrl;
  Attachment? attachment;

  Message({
    required this.id,
    required this.isMe,
    required this.assignmentId,
    this.message,
    this.linkUrl,
    this.timeStamp,
    this.attachment,
  }) : assert(message != null || attachment != null,
            'Message or Attachment must be provided') {
    timeStamp ??= DateTime.now();
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      isMe: json['is_me'] as bool,
      attachment: json['attachment'],
      message: json['message'] as String?,
      linkUrl: json['link_url'] as String?,
      assignmentId: json['assignment_id'] as int,
      timeStamp: DateTime.parse(json['time_stamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'message': message ?? '',
      'link_url': linkUrl ?? '',
      'link_text': linktext ?? '',
      'assignment_id': assignmentId.toString(),
      'time_stamp': (timeStamp ?? DateTime.now()).toIso8601String(),
      'attachments': [],
    };
  }
}

// For Testing Only

final messages = [
  Message(
    id: 1,
    isMe: false,
    assignmentId: 29,
    timeStamp: DateTime.now(),
    message:
        "I need proper assignment according to my requirements which i have added bellow in aattched document. What type of requirements from me you need in this assignment?",
  ),
  Message(
    id: 2,
    isMe: true,
    assignmentId: 29,
    timeStamp: DateTime.now().subtract(const Duration(days: 2)),
    message:
        "Hello Marley, everything is ok? What type of help you needin this assignment?",
    linkUrl: "https://www.github.com/Usama-Azad",
  ),
  Message(
    id: 1,
    isMe: false,
    assignmentId: 29,
    timeStamp: DateTime.now(),
    message:
        "I need proper assignment according to my requirements which i have added bellow in aattched document. What type of requirements from me you need in this assignment?",
  ),
  Message(
    id: 2,
    isMe: true,
    assignmentId: 29,
    timeStamp: DateTime.now().subtract(const Duration(days: 2)),
    message:
        "Hello Marley, everything is ok? What type of help you needin this assignment?",
    linkUrl: "https://www.github.com/Usama-Azad",
  ),
  Message(
    id: 1,
    isMe: false,
    assignmentId: 29,
    timeStamp: DateTime.now(),
    message:
        "I need proper assignment according to my requirements which i have added bellow in aattched document. What type of requirements from me you need in this assignment?",
  ),
  Message(
    id: 2,
    isMe: true,
    assignmentId: 29,
    timeStamp: DateTime.now().subtract(const Duration(days: 2)),
    message:
        "Hello Marley, everything is ok? What type of help you needin this assignment?",
    linkUrl: "https://www.github.com/Usama-Azad",
  ),
];
