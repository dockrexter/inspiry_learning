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

  Future<User?> login({required String email, required String password}) async {
    final response = await _apiManager.post(ApiEndpoints.login, data: {
      'email': email,
      'password': password,
    });
    if (response != null) {
      if (response['status'] == 'ok') {
        return User.fromJson(response['user']);
      }
      Utils.showToast(AppStrings.userNameOrPasswordIncorrect);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<User?> signUp({required User user}) async {
    final response =
        await _apiManager.post(ApiEndpoints.signup, data: user.toJson());
    if (response != null) {
      if (response['status'] == 'ok') {
        return User.fromJson(response['user']);
      }
      Utils.showToast(AppStrings.somethingWentWrong);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<bool> changePassword({required String oldPassword, required String newPassword}) async {
    final response = await _apiManager.put(ApiEndpoints.changePassword, data: {
      'currentPassword': oldPassword,
      'changePassword': newPassword,
      'confirmPassword': newPassword,
    });
    if (response != null) {
      if (response['status'] == 'ok') {
        return true;
      }
      Utils.showToast(AppStrings.somethingWentWrong);
      return false;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return false;
  }

  // Future<bool> deleteUser({required int id}) async {
  //   return ((await _apiManager.delete(APIEndPoint.userEndPoint + '/$id')) != null);
  // }
}
