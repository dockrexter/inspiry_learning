import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/models/user_model.dart';
import 'package:inspiry_learning/manager/api_manager.dart';
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
    final response = await _apiManager.post(APIEndPoint.login, {
      'email': email,
      'password': password,
    });
    if (response != null) {
      if (response['status'] == 'ok') {
        return User.fromJson(response['user']);
      }
      Utils.showToast('username or password is incorrect');
      return null;
    }
    Utils.showToast('something went wrong');
    return null;
  }

  Future<User?> signUp({required User user}) async {
    final response =
        await _apiManager.post(APIEndPoint.signup, user.toJson());
    if (response != null) {
      if (response['status'] == 'ok') {
        return User.fromJson(response['user']);
      }
      Utils.showToast('something went wrong');
      return null;
    }
    Utils.showToast('something went wrong');
    return null;
  }

  // Future<bool> deleteUser({required int id}) async {
  //   return ((await _apiManager.delete(APIEndPoint.userEndPoint + '/$id')) != null);
  // }
}
