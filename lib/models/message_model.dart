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
  int userId;
  bool fromDB;
  String? message;
  String? userName;
  String? userRole;
  int assignmentId;
  MessageType type;
  int? paymentStatus;
  DateTime? timeStamp;
  double? paymentAmount;
  Attachment? attachment;

  Message({
    this.id,
    required this.userId,
    required this.assignmentId,
    this.message,
    this.userName,
    this.userRole,
    this.timeStamp,
    this.attachment,
    this.paymentStatus,
    this.paymentAmount,
    this.fromDB = false,
    this.type = MessageType.text,
  })  : isMe = userId == ActiveUser.instance.user!.userId,
        assert(message != null || attachment != null,
            'Message or Attachment must be provided') {
    final user = ActiveUser.instance.user;
    userRole ??= user?.role;
    timeStamp ??= DateTime.now();
    userName ??= '${user?.firstname} ${user?.lastname}';
  }

  factory Message.fromJson(dynamic json) {
    return Message(
      id: json["id"] as int?,
      userId: json["userId"] as int,
      message: json["message"] as String?,
      userName: json["userName"] as String?,
      userRole: json["userRole"] as String?,
      paymentStatus: json["paymentStatus"] as int?,
      paymentAmount: double.tryParse(json["amount"].toString()) ??
          int.tryParse(json["amount"].toString())?.toDouble(),
      type: MessageType.values[json["type"] as int],
      assignmentId: int.tryParse(json["assignmentId"].toString()) ?? 0,
      timeStamp: DateTime.parse(json["createdAt"] as String),
      attachment: json["message"] == null
          ? Attachment(
              size: json["fileSize"] as int,
              name: json["fileName"] as String,
              downloadUrl: json["url"] as String?,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'type': type.index,
      'userRole': userRole,
      'userName': userName,
      'amount': paymentAmount,
      'paymentStatus': paymentStatus,
      'assignmentId': assignmentId,
      'createdAt': timeStamp?.toUtc().toString(),
      'fileSize': attachment == null ? null : attachment!.size,
      'fileName': attachment == null ? null : attachment!.name,
      'url': attachment == null ? null : attachment!.downloadUrl,
    };
  }
}
