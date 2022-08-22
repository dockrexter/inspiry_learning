import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/manager/api_manager.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:inspiry_learning/globals/api_endpoints.dart';

class PaymentRepository {
  late APIManager _apiManager;

  static final PaymentRepository _paymentRepository =
      PaymentRepository._internal();

  factory PaymentRepository() {
    return _paymentRepository;
  }

  PaymentRepository._internal() {
    _apiManager = APIManager();
  }

  Future<String?> payWithPapal({
    required int messageId,
    required int assignmentId,
    required String itemName,
    required double amount,
    String currency = "USD",
    String description = "",
  }) async {
    final response = await _apiManager.post(ApiEndpoints.payment, data: {
      "itemName": itemName,
      "price": amount,
      "currency": currency,
      "description": description,
      "messageId": messageId,
      "assignmentId": assignmentId,
    });
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        return response["data"]["url"];
      }
      Utils.showToast(response["message"]);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<bool> rejectPayment({
    required int messageId,
  }) async {
    final response = await _apiManager.post(ApiEndpoints.rejectPayment, data: {
      "messageId": messageId,
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
