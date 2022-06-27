import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/manager/shared_preferences_manager.dart';

class User {
  int? userId;
  String? username;
  String? password;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? token;

  User({
    this.userId,
    this.username,
    this.password,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.token,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] as int?;
    username = json['username'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    token = json['token'];
    save();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['password'] = password;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }

  Future<bool> save() async {
    ActiveUser.token = token;
    ActiveUser.userId = userId;
    await SharedPreferencesManager.instance.saveToken(token ?? '');
    return await SharedPreferencesManager.instance.saveUserId(userId ?? -1);
  }
}
