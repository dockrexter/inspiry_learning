class AppStrings {
  // App Title
  static const String appTitle = "Inspiry Learning";

  static const String regexEmailValidation = "[a-zA-Z0-9@.]";
  static const String baseUrl = "https://inspiry-learning-backend.herokuapp.com";
  // static const String baseUrl = "http://192.168.100.180:5000";

  // Login Page
  static const String login = "Login";
  static const String signUp = "Sign Up";
  static const String rememberMe = "Remember Me";
  static const String loginAsUser = "Login as User";
  static const String enterPassword = "Enter Password";
  static const String forgotPassword = "Forgot Password?";
  static const String enterEmailAddress = "Enter Email Address";
  static const String dontHaveAnAccount = "Don't have an account?";
  static const String loginAsProfessional = "Login as Professional";
  static const String needAssignmentHelp = "Need Assignment Help?";

  // Sign Up Page
  static const String signIn = "Sign In";
  static const String password = "Password";
  static const String lastName = "Last Name";
  static const String firstName = "First Name";
  static const String phoneNumber = "Phone Number";
  static const String signUpAsUser = "Sign Up as User";
  static const String haveAnAccount = "Have an account?";
  static const String confirmPassword = "Confirm Password";

  // Forgot Password Page
  static const String send = "Send";
  static const String emailSent = "Email Sent";
  static const String checkInbox = "Check your inbox to reset your password";
  static const String enterEmailForVerification =
      "Please Enter Your Email Adress To Recieve a Verification Code";

  // Home Page
  static const String hello = "Hello";
  static const String status = "Status";
  static const String marley = "Marley!";
  static const String triangleDown = "  ▼";
  static const String dueDate = "Due Date";
  static const String startingDate = "Starting Date";
  static const String submitNewAssignmentForm = "Submit New Assignment Form";
  static const String submittedFormList = "List of assignments forms submitted";

  // Submission Page
  static const String subject = "Subject";
  static const String summary = "Summary";
  static const String thankyou = "Thank You!";
  static const String attachments = "Attachments";
  static const String submitAndProceed = "Submit & Proceed";
  static const String viewAllForms = "View All Submitted Assignments Forms";
  static const String assignmentSubmissionForm = "Assignment Submission Form";
  static const String contactedTime = "You will be contacted within 2-3 hours";

  // Account Setting Page
  static const String save = "Save";
  static const String questionMark = "?";
  static const String addSubAdmin = "Add Sub Admin";
  static const String changePassword = "Change Password";
  static const String accountSetting = "Account Settings";

  // Change Password Page
  static const String done = "Done";
  static const String newPassword = "Enter New Password";
  static const String currentPassword = "Enter Current Password";
  static const String confirmNewPassword = "Confirm New Password";

  // Chat Page
  static const String price = "Price";
  static const String description = "Description";
  static const String chatWithUser = "Chat with User";
  static const String sendQuatation = "Send Quatation";
  static const String priceQuatation = "Price Quatation";
  static const String typeYourMessage = "Type Your Message";
  static const String assignmentDetails = "Assignment Details";
  static const String chatWithProfessionals = "Chat with Professional";

  // User Info Page
  static const String continueAsUser = "Signin as User";
  static const String continueAsProfessional = "Signin as Professional";

  // Sub Admin Page
  static const String fullName = "Full Name";
  static const String registerSubAdmin = "Register Sub Admin";

  // Assignment Details Page
  static const String assignmentDetailsTitle = "Assignment Details";

  // Toast Messages
  static const String subjectRequired = "subject is required";
  static const String somethingWentWrong = "something went wrong";
  static const String updatedSuccessfully = "Updated Successfully";
  static const String allfieldsarerequired = "all fields are required";
  static const String passworddoesnotmatch = "password does not match";
  static const String passwordchangedsuccessfully = "password changed successfully";
  static const String userNameOrPasswordIncorrect= "user name or password is incorrect";
  static const String passwordmustbe6characters = "password must be at least 6 characters";


  static const List<String> items = [
    'New Request',
    'Under Review',
    'Pending Payment',
    'Work in Progress',
    'Work Completed',
  ];
}
