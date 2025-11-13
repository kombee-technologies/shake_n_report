import 'package:shake_n_report/src/core/constants/my_constants.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/core/result/result.dart';
import 'package:shake_n_report/src/data/data_source/remote_data_source/jira_data_source/jira_data_source.dart';
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
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class JiraRepositoriesImpl extends JiraRepository {
  static final JiraRepositoriesImpl _instance =
      JiraRepositoriesImpl._internal();
  static JiraRepositoriesImpl get instance => _instance;

  final JiraDataSource _jiraDataSource;

  JiraRepositoriesImpl._internal({
    JiraDataSource? jiraDataSource,
  }) : _jiraDataSource = jiraDataSource ?? JiraDataSourceImpl.instance;

  @override
  Future<Result<AccessTokenResponse>> getAccessToken(
      GetAccessTokenRequest request) async {
    try {
      final AccessTokenResponse response =
          await _jiraDataSource.getAccessToken(request);
      return Success<AccessTokenResponse>(response);
    } catch (e) {
      if (e is BaseException) {
        return Failure<AccessTokenResponse>(e);
      }
      return Failure<AccessTokenResponse>(
          GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Result<List<AccessibleResourcesResponse>>>
      getAccessibleResources() async {
    try {
      final List<AccessibleResourcesResponse> response =
          await _jiraDataSource.getAccessibleResources();
      return Success<List<AccessibleResourcesResponse>>(response);
    } catch (e) {
      if (e is BaseException) {
        return Failure<List<AccessibleResourcesResponse>>(e);
      }
      return Failure<List<AccessibleResourcesResponse>>(
          GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Result<List<JiraAssignableUsersResponse>>> getJiraAssignableUsers(
      CommonParamsRequest request) async {
    try {
      final List<JiraAssignableUsersResponse> response =
          await _jiraDataSource.getJiraAssignableUsers(request);
      return Success<List<JiraAssignableUsersResponse>>(response);
    } catch (e) {
      if (e is BaseException) {
        return Failure<List<JiraAssignableUsersResponse>>(e);
      }
      return Failure<List<JiraAssignableUsersResponse>>(
          GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Result<List<JiraIssueTypeResponse>>> getJiraIssueTypes(
      CommonParamsRequest request) async {
    try {
      final List<JiraIssueTypeResponse> response =
          await _jiraDataSource.getJiraIssueTypes(request);
      return Success<List<JiraIssueTypeResponse>>(response);
    } catch (e) {
      if (e is BaseException) {
        return Failure<List<JiraIssueTypeResponse>>(e);
      }
      return Failure<List<JiraIssueTypeResponse>>(
          GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Result<JiraProjectsResponse>> getJiraProjects(
      CommonParamsRequest request) async {
    try {
      final JiraProjectsResponse response =
          await _jiraDataSource.getJiraProjects(request);
      return Success<JiraProjectsResponse>(response);
    } catch (e) {
      if (e is BaseException) {
        return Failure<JiraProjectsResponse>(e);
      }
      return Failure<JiraProjectsResponse>(
          GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Result<void>> addAttachmentToTicket(
      CommonParamsRequest params, List<String> filePaths) async {
    try {
      await _jiraDataSource.addAttachmentToTicket(params, filePaths);
      return const Success<void>(null);
    } catch (e) {
      if (e is BaseException) {
        return Failure<void>(e);
      }
      return Failure<void>(GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Result<void>> assignTicket(
      CommonParamsRequest params, AssignIssueRequest request) async {
    try {
      await _jiraDataSource.assignTicket(params, request);
      return const Success<void>(null);
    } catch (e) {
      if (e is BaseException) {
        return Failure<void>(e);
      }
      return Failure<void>(GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Result<CreateJiraIssueResponse>> createJiraTicket(
      CommonParamsRequest params, CreateJiraIssueRequest request) async {
    try {
      final CreateJiraIssueResponse response =
          await _jiraDataSource.createJiraTicket(params, request);
      return Success<CreateJiraIssueResponse>(response);
    } catch (e) {
      if (e is BaseException) {
        return Failure<CreateJiraIssueResponse>(e);
      }
      return Failure<CreateJiraIssueResponse>(
          GeneralException(MyConstants.somethingWentWrong));
    }
  }
}
