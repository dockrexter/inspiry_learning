import 'package:inspiry_learning/manager/api_manager.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:inspiry_learning/globals/api_endpoints.dart';
import 'package:inspiry_learning/models/assignment_model.dart';

class AssignmentRepository {
  late APIManager _apiManager;

  static final AssignmentRepository _assignmentRepository = AssignmentRepository._internal();

  factory AssignmentRepository() {
    return _assignmentRepository;
  }

  AssignmentRepository._internal() {
    _apiManager = APIManager();
  }

  Future<List<Assignment>> getAssignments(String userId) async {
    final response = await _apiManager.get(
      ApiEndpoints.getAssignments,
      params: {
        'user_id': userId,
      },
    );
    if (response.statusCode == 200) {
      final assignments = (response.data as List)
          .map((assignment) => Assignment.fromJson(assignment))
          .toList();
      return assignments;
    } else {
      throw Exception(AppStrings.somethingWentWrong);
    }
  }

  Future<Assignment> createAssignment(Assignment assignment) async {
    final response = await _apiManager.post(
      ApiEndpoints.createAssignment,
      data: assignment.toJson(),
    );
    if (response.statusCode == 200) {
      final assignment = Assignment.fromJson(response.data);
      return assignment;
    } else {
      throw Exception(AppStrings.somethingWentWrong);
    }
  }
}
