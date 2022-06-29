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

  Future<dynamic> getAssignments(int userId) async {
    final response = await _apiManager.get(
      ApiEndpoints.getAssignments,
      params: {
        'user_id': userId,
      },
    );
    if (response != null) {
      final assignments = response
          .map((assignment) => Assignment.fromJson(assignment))
          .toList();
      return assignments;
    } else {
      throw Exception(AppStrings.somethingWentWrong);
    }
  }

  Future<bool> createAssignment(Assignment assignment) async {
    final response = await _apiManager.post(
      ApiEndpoints.createAssignment,
      data: {"values": assignment.toJson()},
    );
    return (response != null && response == 'insertion sucess');
    // if (response != null) {
    //   return Assignment.fromJson(response.data);
    // } else {
    //   throw Exception(AppStrings.somethingWentWrong);
    // }
  }
}
