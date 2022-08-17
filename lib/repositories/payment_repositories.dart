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
    required String itemName,
    required double amount,
    String currency = "USD",
    String description = "",
  }) async {
    final response = await _apiManager.post(ApiEndpoints.payment, data: {
      "itemName": itemName,
      "price": amount,
      "currency": currency,
      "description": description
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
}
