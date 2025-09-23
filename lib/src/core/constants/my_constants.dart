class MyConstants {
  static const String selectTools = 'Select Tools';
  static const String selectToolsBodyt =
      'Please Select Project Management Tools To Continue Reporting Bugs';

  static const double borderRadius = 14.0;
  static const int maxAttachments = 5;

  /// jira keys
  static const String jiraClientId = 'client_id';
  static const String jiraScope = 'scope';
  static const String jiraRedirectUri = 'redirect_uri';
  static const String jiraAccessCode = 'code';
  static const String jiraLogin = 'Jira Login';
  static const String jiraScopes =
      'read:jira-work write:jira-work read:jira-user read:me';

  static const String connectionTimeout =
      'The connection has timed out. Please try again later.';
  static const String badCertificate =
      'The security certificate is invalid. Unable to establish a secure connection.';
  static const String unauthorizedAccess =
      'Access denied. You do not have the necessary permissions.';
  static const String routeNotFound =
      'The requested route could not be found. Please check the URL.';
  static const String serverError =
      'An error occurred on the server. Please try again later.';
  static const String requestCancelled =
      'The request was cancelled. Please try again.';
  static const String connectionError =
      'There was an error connecting to the server. Please check your connection.';
  static const String somethingWentWrong =
      'Oops! Something went wrong. Please try again later.';

  static const String authorizationCode = 'authorization_code';
  static const String refreshToken = 'refresh_token';

  static String get state => 'state_${DateTime.now().millisecondsSinceEpoch}';
}
