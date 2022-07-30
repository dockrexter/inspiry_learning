import 'dart:convert';

import 'package:inspiry_learning/manager/shared_preferences_manager.dart';

class User {
  int? userId;

  String? username;
  String? password;
  String? firstname;
  String? lastname;

  String? email;
  String? phone;

  String? role;
  String? token;

  User({
    this.userId,
    this.username,
    this.password,
    this.firstname,
    this.lastname,
    this.role,
    this.email,
    this.phone,
    this.token,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] as int?;
    username = json['username'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    role = json['role'];
    email = json['email'];
    phone = json['phone'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['password'] = password;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['role'] = role;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }

  Map<String, dynamic> toJsonForSave() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    data['token'] = token;
    return data;
  }

  Map<String, dynamic> toJsonForUpdate() {
    final data = <String, dynamic>{};
    data['firstName'] = firstname;
    data['lastName'] = lastname;
    data['phone'] = phone;
    data['user_id'] = userId;
    return data;
  }

  User copyWith({
    int? userId,
    String? username,
    String? password,
    String? firstname,
    String? lastname,
    String? role,
    String? email,
    String? phone,
    String? token,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      password: password ?? this.password,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      token: token ?? this.token,
    );
  }

  static Future<User?> getUser() async {
    final user = SharedPreferencesManager.instance.getUser();
    if (user == null) return null;
    return User.fromJson(json.decode(user));
  }

  Future<bool> save() async {
    return await SharedPreferencesManager.instance
        .saveUser(json.encode(toJsonForSave()));
  }

  static Future<bool> remove() async {
    return await SharedPreferencesManager.instance.removeUser();
  }
}
