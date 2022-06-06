enum UserType{
  user,
  admin,
}

class UserTypeHelper{
  static UserType userType = UserType.user;

  static UserType getUserType(){
    return userType;
  }

  static void setUserType(UserType type){
    userType = type;
  }

  static void continueAsUser(){
    setUserType(UserType.user);
  }

  static void continueAsAdmin() {
    setUserType(UserType.admin);
  }

  static bool isUser(){
    return userType == UserType.user;
  }

  static bool isAdmin(){
    return userType == UserType.admin;
  }

}