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

  Future<User?> login(
      {required String email,
      required String password,
      required String role}) async {
    final response = await _apiManager.post(ApiEndpoints.login, data: {
      'email': email,
      'password': password,
      'role': role,
    });
    if (response != null) {
      if (response['status'] == 'ok') {
        var user = User.fromJson(response['user']);
        await user.save();
        return user;
      }
      Utils.showToast(AppStrings.userNameOrPasswordIncorrect);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<User?> signUp({required User user, bool addSubAdmin = false}) async {
    final response =
        await _apiManager.post(ApiEndpoints.signup, data: user.toJson());
    if (response != null) {
      if (response['status'] == 'ok') {
        var user = User.fromJson(response['user']);
        if (!addSubAdmin) {
          await user.save();
        }
        return user;
      }
      Utils.showToast(AppStrings.somethingWentWrong);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<User?> updateUser({required User user}) async {
    final response = await _apiManager.post(ApiEndpoints.updateUser, data: {
      "values": user.toJsonForUpdate(),
    });
    if (response != null) {
      if (response['status'] == 'ok') {
        user.save();
        return user;
      }
      Utils.showToast(AppStrings.somethingWentWrong);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<bool> changePassword(
      {required int userId,
      required String oldPassword,
      required String newPassword}) async {
    final response = await _apiManager.post(ApiEndpoints.changePassword, data: {
      "values": {
        'user_id': userId,
        'currentPassword': oldPassword,
        'changePassword': newPassword,
        'confirmPassword': newPassword,
      }
    });
    if (response != null) {
      if (response['status'] == 'ok') {
        return true;
      } else if (response['status'] == 'error') {
        Utils.showToast(response['message']);
        return false;
      }
    } else {
      Utils.showToast(AppStrings.somethingWentWrong);
      return false;
    }
    return false;
  }

  // Future<bool> deleteUser({required int id}) async {
  //   return ((await _apiManager.delete(APIEndPoint.userEndPoint + '/$id')) != null);
  // }
}
