class ApiEndpoints {
  static const String login = '/api/users/login';
  static const String addToken = '/api/token/add';
  static const String payment = '/api/payment/pay';
  static const String signup = '/api/users/register';
  static const String removeToken = '/api/token/remove';
  static const String updateUser = '/api/users/updateUser';
  static const String removeUser = '/api/users/removeUser';
  static const String rejectPayment = '/api/payment/reject';
  static const String changePassword = '/api/users/changePassword';
  static const String uploadAttachments = '/api/attachments/upload';
  static const String forgotPassword = 'api/users/sendPasswordResetLink';
  static const String getAttachments = '/api/assignments/getAttachments';
  static const String updateAssignee = '/api/assignments/updateAssignee';
  static const String getAllNotification = '/api/users/getAllNotifications';
  static const String readSingleNotification =
      '/api/users/singleNotificationReaded';
  static const String allSingleNotificationread = '/api/users/notificationReaded';
  static const String getAssignments = '/api/assignments/getUserAssignments';
  static const String getAssignmentsSingledetail =
      '/api/assignments/getAssignmentById';
  static const String updateAssignmentStatus = '/api/assignments/updateStatus';
  static const String createAssignment =
      '/api/assignments/createUserAssignment';
  static const String getAllDueAssignments =
      '/api/assignments/getAllDueAssignments';
  static const String getAssignmentsByMonth =
      '/api/assignments/getCurrentMonthAssignments';
}
