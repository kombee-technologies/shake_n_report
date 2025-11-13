import 'package:shake_n_report/src/core/result/result.dart';
import 'package:shake_n_report/src/data/models/jira/request/assign_issue_request.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/models/jira/request/create_jira_issue_request.dart';
import 'package:shake_n_report/src/data/models/jira/request/get_access_token_request.dart';
import 'package:shake_n_report/src/data/models/jira/response/access_token_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/accessible_resource_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/create_jira_issue_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_assignable_users_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_issue_type_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_project_response.dart';

abstract class JiraRepository {
  /// Fetches the access token from the Jira API.
  ///
  /// Returns an [AccessTokenResponse] containing the access token.
  Future<Result<AccessTokenResponse>> getAccessToken(
      GetAccessTokenRequest request);

  /// Fetches the accessible resources from the Jira API.
  ///
  /// Returns a list of [AccessibleResourcesResponse] containing the accessible resources.
  Future<Result<List<AccessibleResourcesResponse>>> getAccessibleResources();

  /// Fetches the projects from the Jira API.
  ///
  /// Returns a [JiraProjectsResponse] containing the projects.
  Future<Result<JiraProjectsResponse>> getJiraProjects(
      CommonParamsRequest request);

  /// Fetches the issue types from the Jira API.
  ///
  /// Returns a list of [JiraIssueTypeResponse]
  Future<Result<List<JiraIssueTypeResponse>>> getJiraIssueTypes(
      CommonParamsRequest request);

  /// Fetches the assignable users from the Jira API.
  ///
  /// Returns a list of [JiraAssignableUsersResponse]
  Future<Result<List<JiraAssignableUsersResponse>>> getJiraAssignableUsers(
      CommonParamsRequest request);

  /// Creates a new Jira ticket with the specified parameters and request data.
  ///
  /// [params] - Common parameters required for the request.
  /// [request] - The details of the Jira issue to be created.
  ///
  /// Returns a [CreateJiraIssueResponse] containing the result of the operation.
  Future<Result<CreateJiraIssueResponse>> createJiraTicket(
      CommonParamsRequest params, CreateJiraIssueRequest request);

  /// Assigns a Jira ticket to a user.
  ///
  /// [params] - Common parameters required for the request.
  /// [request] - The assignment details including ticket and user information.
  Future<Result<void>> assignTicket(
      CommonParamsRequest params, AssignIssueRequest request);

  /// Adds an attachment to a Jira ticket.
  ///
  /// [params] - Common parameters required for the request.
  /// [filePaths] - List of file paths to attach to the ticket.
  Future<Result<void>> addAttachmentToTicket(
      CommonParamsRequest params, List<String> filePaths);
}
