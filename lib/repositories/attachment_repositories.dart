import 'package:dio/dio.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/manager/api_manager.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:inspiry_learning/globals/api_endpoints.dart';
import 'package:inspiry_learning/models/attachment_model.dart';

class AttachmentRepository {
  late APIManager _apiManager;

  static final AttachmentRepository _attachmentRepository =
      AttachmentRepository._internal();

  factory AttachmentRepository() {
    return _attachmentRepository;
  }

  AttachmentRepository._internal() {
    _apiManager = APIManager();
  }

  Future<String?> uploadAttachment({
    required Attachment attachment,
  }) async {
    final response = await _apiManager.post(
      ApiEndpoints.uploadAttachments,
      data: FormData.fromMap({
        "file": await MultipartFile.fromFile(attachment.path!),
      }),
    );
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

  Future<List<Attachment>?> getAttachment(int id) async {
    final response = await _apiManager.post(ApiEndpoints.getAttachments, data: {
      "assignment_id": id,
    });
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        return response["data"]
            .map<Attachment>((attachment) => Attachment(
                  size: attachment["fileSize"],
                  name: attachment["fileName"],
                  downloadUrl: attachment["url"],
                ))
            .toList();
      }
      Utils.showToast(response["message"]);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }
}
