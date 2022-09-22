import 'package:dio/dio.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:inspiry_learning/manager/api_manager.dart';
import 'package:inspiry_learning/globals/api_endpoints.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/models/single_assaignment_model.dart';

class AssignmentRepository {
  late APIManager _apiManager;

  static final AssignmentRepository _assignmentRepository =
      AssignmentRepository._internal();

  factory AssignmentRepository() {
    return _assignmentRepository;
  }

  AssignmentRepository._internal() {
    _apiManager = APIManager();
  }
  /* Assignment Detail */
  Future<AssignmentDetail?> getassignmentdetail({String? assaignmentId}) async {
    final response = await _apiManager.post(
      ApiEndpoints.getAssignmentsSingledetail,
      data: {"assignment_id": assaignmentId},
    );
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        final AssignmentDetail assignments =
            AssignmentDetail.fromJson(response['data']);
        return assignments;
      }
      Utils.showToast(response["message"]);
      return null;
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return null;
  }

  Future<List<Assignment>> getAssignments(int userId) async {
    final response = await _apiManager.get(ApiEndpoints.getAssignments);
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        final List<Assignment> assignments = (response["data"] as List<dynamic>)
            .map((assignment) => Assignment.fromJson(assignment))
            .toList();
        return assignments;
      }
      Utils.showToast(response["message"]);
      return [];
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return [];
  }

  Future<List<Assignment>> getAllDueAssignments() async {
    final response = await _apiManager.post(
      ApiEndpoints.getAllDueAssignments,
      data: {"current_date": DateTime.now().toString().split(' ')[0]},
    );
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        final List<Assignment> assignments = (response["data"] as List<dynamic>)
            .map((assignment) => Assignment.fromJson(assignment))
            .toList();
        return assignments;
      }
      Utils.showToast(response["message"]);
      return [];
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return [];
  }

  Future<List<Assignment>> getAssignmentsByMonth(int month, int year) async {
    final response = await _apiManager.post(
      ApiEndpoints.getAssignmentsByMonth,
      data: {"current_month": month, "current_year": year},
    );
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        final List<Assignment> assignments = (response["data"] as List<dynamic>)
            .map((assignment) => Assignment.fromJson(assignment))
            .toList();
        return assignments;
      }
      Utils.showToast(response["message"]);
      return [];
    }
    Utils.showToast(AppStrings.somethingWentWrong);
    return [];
  }

  Future<bool> createAssignment(Assignment assignment) async {
    List<MultipartFile> files = [];
    if (assignment.attachments != null) {
      for (var attachment in assignment.attachments!) {
        files.add(await MultipartFile.fromFile(attachment.path!));
      }
    }
    final response = await _apiManager.post(
      ApiEndpoints.createAssignment,
      data: FormData.fromMap({
        "files": files,
        "subject": assignment.subject,
        "summary": assignment.summary,
        "deadline": assignment.deadline,
      }),
    );
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

  Future<bool> updateAssignmentStatus(int assignmentId, int status) async {
    final response = await _apiManager.post(
      ApiEndpoints.updateAssignmentStatus,
      data: {"assignment_id": assignmentId, "status": status},
    );
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        return true;
      }
      Utils.showToast(response["message"]);
      return false;
    }
    return false;
  }

  Future<bool> updateAssignee(int assignmentId, String assignee) async {
    final response = await _apiManager.post(
      ApiEndpoints.updateAssignee,
      data: {"assignment_id": assignmentId, "assignee": assignee},
    );
    if (response != null) {
      if (response["status"] == "ok" && response["statusCode"] == 200) {
        return true;
      }
      Utils.showToast(response["message"]);
      return false;
    }
    return false;
  }
}
