import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/attachment_model.dart';

enum MessageType {
  text,
  offer,
  attachment,
}

class Message {
  int? id;
  bool isMe;
  String? message;
  int assignmentId;
  MessageType type;
  int? paymentStatus;
  DateTime? timeStamp;
  double? paymentAmount;
  Attachment? attachment;

  Message({
    this.id,
    required this.isMe,
    required this.assignmentId,
    this.message,
    this.timeStamp,
    this.attachment,
    this.paymentStatus,
    this.paymentAmount,
    this.type = MessageType.text,
  }) : assert(message != null || attachment != null,
            'Message or Attachment must be provided') {
    timeStamp ??= DateTime.now();
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    int? userId = json["user_id"] ?? json["admin_id"];
    return Message(
      id: json['id'] as int?,
      // attachment: json['attachment'],
      message: json['message'] as String?,
      paymentStatus: json['status'] as int?,
      paymentAmount: json['amount'] as double?,
      assignmentId: json['assignment_id'] as int,
      type: MessageType.values[json['type'] as int],
      timeStamp: DateTime.parse(json['time_stamp']),
      isMe: userId == null ? false : userId == ActiveUser.instance.user!.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'type': type.index,
      'amount': paymentAmount,
      'status': paymentStatus,
      'assignment_id': assignmentId.toString(),
      'time_stamp': timeStamp?.toUtc().toString(),
      'user_type': UserTypeHelper.isAdmin() ? 1 : 0,
      'attachment': attachment == null ? null : attachment!.toJson(),
    };
  }
}
