import 'package:inspiry_learning/manager/api_manager.dart';
import 'package:inspiry_learning/globals/api_endpoints.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/all_notification_model.dart';
import 'package:inspiry_learning/models/all_notification_read_model.dart';
import 'package:inspiry_learning/models/single_notification_read_model.dart';

class AllNotifactionRepository {
  late APIManager _apiManager;
  static final AllNotifactionRepository _allnotificationRepository =
      AllNotifactionRepository._internal();
  factory AllNotifactionRepository() {
    return _allnotificationRepository;
  }
  AllNotifactionRepository._internal() {
    _apiManager = APIManager();
  }

  Future<SingleNotificationRead?> singlenotificationread(
      String? notificationId) async {
    final response = await _apiManager.post(
      ApiEndpoints.readSingleNotification,
      data: {"id": notificationId},
    );
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        final SingleNotificationRead assignments =
            SingleNotificationRead.fromJson(response);
        return assignments;
      }
      AppUtils.showToast(response["message"]);
      return null;
    }
    AppUtils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<AllNotificationRead?> allnotificationread(String? userId) async {
    final response = await _apiManager.post(
      ApiEndpoints.allSingleNotificationread,
      data: {"userId": userId},
    );
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        final AllNotificationRead assignments =
            AllNotificationRead.fromJson(response);
        return assignments;
      }
      AppUtils.showToast(response["message"]);
      return null;
    }
    AppUtils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<List<AllNotificationData>> getallNotification() async {
    final response = await _apiManager.get(ApiEndpoints.getAllNotification);
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        final List<AllNotificationData> notification = (response["data"]
                as List<dynamic>)
            .map((notification) => AllNotificationData.fromJson(notification))
            .toList();
        return notification;
      }
      AppUtils.showToast(response["message"]);
      return [];
    }
    AppUtils.showToast(AppStrings.somethingWentWrong);
    return [];
  }
}
