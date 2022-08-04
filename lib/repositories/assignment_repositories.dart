import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/manager/api_manager.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:inspiry_learning/globals/api_endpoints.dart';
import 'package:inspiry_learning/models/assignment_model.dart';

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

  Future<List<Assignment>> getAssignments(int userId) async {
    final response = await _apiManager.get(
      ApiEndpoints.getAssignments,
      params: {"user_id": userId},
    );
    if (response != null) {
      final List<Assignment> assignments =
          (response["assignments"] as List<dynamic>)
              .map((assignment) => Assignment.fromJson(assignment))
              .toList();
      return assignments;
    } else {
      Utils.showToast(AppStrings.somethingWentWrong);
    }
    return [];
  }

  Future<List<Assignment>> getAllDueAssignments() async {
    final response = await _apiManager.post(
      ApiEndpoints.getAllDueAssignments,
      data: {"current_date": DateTime.now().toString().split(' ')[0]},
    );
    if (response != null) {
      final List<Assignment> assignments =
          (response["assignments"] as List<dynamic>)
              .map((assignment) => Assignment.fromJson(assignment))
              .toList();
      return assignments;
    } else {
      Utils.showToast(AppStrings.somethingWentWrong);
      return [];
    }
  }

  Future<dynamic> getAssignmentsByDate(DateTime date) async {
    final response = await _apiManager.post(
      ApiEndpoints.getAssignmentsByDate,
      data: {"deadline": date.toString().split(' ')[0]},
    );
    if (response != null) {
      final assignments = response
          .map((assignment) => Assignment.fromJson(assignment))
          .toList();
      return assignments;
    } else {
      Utils.showToast(AppStrings.somethingWentWrong);
    }
    return null;
  }

  Future<List<Assignment>> getAssignmentsByMonth(
      String month, String year) async {
    final response = await _apiManager.post(
      ApiEndpoints.getAssignmentsByMonth,
      data: {"currentMonth": month, "currentYear": year},
    );
    if (response != null) {
      final List<Assignment> assignments =
          (response["assignments"] as List<dynamic>)
              .map((assignment) => Assignment.fromJson(assignment))
              .toList();
      return assignments;
    } else {
      Utils.showToast(AppStrings.somethingWentWrong);
    }
    return [];
  }

  Future<bool> createAssignment(Assignment assignment) async {
    if (assignment.attachments != null) {
      for (var attachment in assignment.attachments!) {
        if (!await attachment.upload()) return false;
      }
    }
    final response = await _apiManager.post(
      ApiEndpoints.createAssignment,
      data: {"values": assignment.toJson()},
    );
    return (response != null &&
        response["status"] == "ok" &&
        response["message"] == "insertion sucess");
  }

  Future<bool> updateAssignmentStatus(int assignmentId, String status) async {
    final response = await _apiManager.post(
      ApiEndpoints.updateAssignmentStatus,
      data: {"id": assignmentId, "status": status},
    );
    return (response != null);
  }

  Future<bool> updateAssignee(int assignmentId, String assignee) async {
    final response = await _apiManager.post(
      ApiEndpoints.updateAssignee,
      data: {"id": assignmentId, "assignee": assignee},
    );
    return (response != null);
  }
}
