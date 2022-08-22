import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:inspiry_learning/manager/api_manager.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:inspiry_learning/globals/api_endpoints.dart';

class UserRepository {
  late APIManager _apiManager;

  static final UserRepository _userRepository = UserRepository._internal();

  factory UserRepository() {
    return _userRepository;
  }

  UserRepository._internal() {
    _apiManager = APIManager();
  }

  Future<User?> login({
    required String email,
    required String password,
    required String role,
    bool rememberMe = true,
  }) async {
    final response = await _apiManager.post(ApiEndpoints.login, data: {
      "email": email,
      "password": password,
      "role": role,
    });
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        var user = User.fromJson(response["data"]);
        if (rememberMe) await user.save();
        await Utils.addTokenToBackend();
        return user;
      }
      Utils.showToast(response["message"]);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<User?> signUp({required User user, bool addSubAdmin = false}) async {
    final response = await _apiManager.post(
      ApiEndpoints.signup,
      data: user.toJson(),
    );
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        var user = User.fromJson(response["data"]);
        if (!addSubAdmin) {
          await user.save();
          await Utils.addTokenToBackend();
        }
        return user;
      }
      Utils.showToast(response["message"]);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<User?> updateUser({required User user}) async {
    final response = await _apiManager.post(
      ApiEndpoints.updateUser,
      data: user.toJsonForUpdate(),
    );
    if (response != null) {
      Utils.showToast(response["message"]);
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        await user.save();
        return user;
      }
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await _apiManager.post(ApiEndpoints.changePassword, data: {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });
    if (response != null) {
      Utils.showToast(response["message"]);
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        return true;
      }
      return false;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return false;
  }

  Future<bool> forgotPassword({required String email}) async {
    final response = await _apiManager.post(ApiEndpoints.forgotPassword, data: {
      "email": email,
    });
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        return true;
      }
      Utils.showToast(response["message"]);
      return false;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return false;
  }
}
