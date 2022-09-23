import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:inspiry_learning/manager/api_manager.dart';
import 'package:inspiry_learning/globals/api_endpoints.dart';

class FcmTokenRepository {
  late APIManager _apiManager;

  static final FcmTokenRepository _fcmTokenRepository =
      FcmTokenRepository._internal();

  factory FcmTokenRepository() {
    return _fcmTokenRepository;
  }

  FcmTokenRepository._internal() {
    _apiManager = APIManager();
  }

  Future<String?> addToken({required String token}) async {
    final response = await _apiManager.post(ApiEndpoints.addToken, data: {
      // "id": ActiveUser.instance.user!.userId,
      "token": token,
    });
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        return response["data"]["token"];
      }
      Utils.showToast(response["message"]);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<String?> removeToken({required String token}) async {
    final response = await _apiManager.post(ApiEndpoints.removeToken, data: {
      "token": token,
    });
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        return response["data"]["token"];
      }
      Utils.showToast(response["message"]);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }
}
