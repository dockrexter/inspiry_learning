class AllNotificationData {
  int? id;
  int? userID;
  String? message;
  String? title;
  String? assignmentID;
  bool? isRead;
  String? createdAt;
  String? updatedAt;

  AllNotificationData(
      {this.id,
      this.userID,
      this.message,
      this.title,
      this.assignmentID,
      this.isRead,
      this.createdAt,
      this.updatedAt});

  AllNotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    message = json['message'];
    title = json['title'];
    assignmentID = json['assignmentID'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['message'] = message;
    data['title'] = title;
    data['assignmentID'] = assignmentID;
    data['isRead'] = isRead;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
