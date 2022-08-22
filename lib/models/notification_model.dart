class Notification {
  int? id;
  int userId;
  String notification;
  DateTime timeStamp;

  Notification({
    this.id,
    required this.userId,
    required this.notification,
    required this.timeStamp,
  });

  factory Notification.fromJson(dynamic json) {
    return Notification(
      id: json["id"] as int?,
      userId: json["userId"] as int,
      notification: json["notification"] as String,
      timeStamp: DateTime.parse(json["createdAt"] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'notification': notification,
      'createdAt': timeStamp.toUtc().toString(),
    };
  }
}
