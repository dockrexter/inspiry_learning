class SingleNotificationRead {
  String? status;
  String? message;
  int? statusCode;

  SingleNotificationRead({this.status, this.message, this.statusCode});

  SingleNotificationRead.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }
}
