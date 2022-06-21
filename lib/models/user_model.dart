import 'package:inspiry_learning/manager/shared_preferences_manager.dart';

class User {
  String? username;
  String? password;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? token;

  User({
    this.username,
    this.password,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.token,
  });

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
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
    return await SharedPreferencesManager.instance.saveToken(token ?? '');
  }
}
