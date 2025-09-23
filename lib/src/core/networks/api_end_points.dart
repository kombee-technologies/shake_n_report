class ApiEndPoints {
  static const String location = 'http://ip-api.com/json';

  // Jira API Endpoints
  static const String oAuthTokenJira = 'https://auth.atlassian.com/oauth/token';
  static const String getAccessibleResourcesJira =
      'https://api.atlassian.com/oauth/token/accessible-resources';

  static String getJiraProjects(String cloudId) =>
      'https://api.atlassian.com/ex/jira/$cloudId/rest/api/3/project/search';

  static String getJiraProjectIssueType(String cloudId, String projectId) =>
      'https://api.atlassian.com/ex/jira/$cloudId/rest/api/3/issuetype/project?projectId=$projectId';

  static String getAssignableUsersJira(String cloudId, String projectKey) =>
      'https://api.atlassian.com/ex/jira/$cloudId/rest/api/3/user/assignable/search?project=$projectKey';

  static String createIssueJira(String cloudId) =>
      'https://api.atlassian.com/ex/jira/$cloudId/rest/api/3/issue';

  static String attachFileJira(String cloudId, String issueId) =>
      'https://api.atlassian.com/ex/jira/$cloudId/rest/api/3/issue/$issueId/attachments';

  static String assignIssueJira(String cloudId, String issueId) =>
      'https://api.atlassian.com/ex/jira/$cloudId/rest/api/3/issue/$issueId/assignee';
}
