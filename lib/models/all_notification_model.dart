class AllNotificationData {
//   List<Data>? data;
//   String? status;
//   String? message;
//   int? statusCode;

//   AllNotificationData({this.data, this.status, this.message, this.statusCode});

//   AllNotificationData.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//     status = json['status'];
//     message = json['message'];
//     statusCode = json['statusCode'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = status;
//     data['message'] = message;
//     data['statusCode'] = statusCode;
//     return data;
//   }
// }

// class Data {
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
