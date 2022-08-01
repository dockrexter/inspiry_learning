class ApiEndpoints {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String updateUser = '/user/updateUser';
  static const String changePassword = '/user/changePassword';
  static const String getAssignments = '/assignment/getAssignments';
  static const String updateAssignee = '/assignment/updateAssignee';
  static const String createAssignment = '/assignment/postAssignments';
  static const String updateAssignmentStatus = '/assignment/changeStatus';
  static const String getAssignmentsByDate = '/assignment/getAssignmentsAdmin';
  static const String getAssignmentsByMonth = '/assignment/getCurrentMonthAssignments';

  static const String uploadAttachments = '/api/upload';
}