import 'dart:typed_data';

class Message {
  int id;
  bool isMe;
  int assignmentId;
  String? message;
  DateTime? timeStamp;
  String? linktext, linkUrl;
  List<Uint8List?>? attachments;

  Message({
    required this.id,
    required this.isMe,
    required this.assignmentId,
    this.message,
    this.linkUrl,
    this.linktext,
    this.timeStamp,
    this.attachments,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      isMe: json['is_me'] as bool,
      attachments: json['attachments'],
      message: json['message'] as String?,
      linkUrl: json['link_url'] as String?,
      linktext: json['link_text'] as String?,
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
    linktext: "Click Here to make the payment",
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
    linktext: "Click Here to make the payment",
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
    linktext: "Click Here to make the payment",
    linkUrl: "https://www.github.com/Usama-Azad",
  ),
];
