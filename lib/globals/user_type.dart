import 'package:inspiry_learning/manager/shared_preferences_manager.dart';

enum UserType{
  user,
  admin,
}

enum AdminType{
  subAdmin,
  superAdmin,
}

class UserTypeHelper{
  static UserType userType = UserType.user;
  static AdminType adminType = AdminType.superAdmin;

  static UserType getUserType(){
    return userType;
  }

  static void setUserType(UserType type){
    userType = type;
  }

  static void setAdminTypeAsSubAdmin() {
    adminType = AdminType.subAdmin;
  }

  static void continueAsUser({bool save_ = true}){
    setUserType(UserType.user);
    if (save_) save();
  }

  static void continueAsAdmin({bool save_ = true}) {
    setUserType(UserType.admin);
    if (save_) save();
  }

  static bool isUser(){
    return userType == UserType.user;
  }

  static bool isAdmin(){
    return userType == UserType.admin;
  }

  static bool isSuperAdmin() {
    return adminType == AdminType.superAdmin;
  }

  static bool initUserType(){
    final isAdmin = SharedPreferencesManager.instance.getIsAdmin();
    if(isAdmin == null){
      return false;
    }
    if(isAdmin){
      continueAsAdmin(save_: false);
      return true;
    }
    continueAsUser(save_: false);
    return true;
  }

  static Future<bool> save() async {
    return await SharedPreferencesManager.instance.setIsAdmin(isAdmin());
  }

}