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
    required double amount,
  }) async {
    final response =
        await _apiManager.post(ApiEndpoints.payment, data: {"amount": amount});
    if (response != null) {
      // if (response["status"] == "ok") {
      return response["url"];
      // }
      // Utils.showToast(AppStrings.somethingWentWrong);
      // return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }
}
