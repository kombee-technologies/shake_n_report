import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shake_n_report/src/core/constants/my_constants.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
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
  final JiraDataSource _jiraDataSource;

  JiraRepositoriesImpl(this._jiraDataSource);

  @override
  Future<Either<BaseException, AccessTokenResponse>> getAccessToken(
      GetAccessTokenRequest request) async {
    try {
      final AccessTokenResponse response =
          await _jiraDataSource.getAccessToken(request);
      return right(response);
    } catch (e) {
      if ((e is DioException) && (e.error is BaseException)) {
        return left(e.error as BaseException);
      }
      return left(GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Either<BaseException, List<AccessibleResourcesResponse>>>
      getAccessibleResources() async {
    try {
      final List<AccessibleResourcesResponse> response =
          await _jiraDataSource.getAccessibleResources();
      return right(response);
    } catch (e) {
      if ((e is DioException) && (e.error is BaseException)) {
        return left(e.error as BaseException);
      }
      return left(GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Either<BaseException, List<JiraAssignableUsersResponse>>>
      getJiraAssignableUsers(CommonParamsRequest request) async {
    try {
      final List<JiraAssignableUsersResponse> response =
          await _jiraDataSource.getJiraAssignableUsers(request);
      return right(response);
    } catch (e) {
      if ((e is DioException) && (e.error is BaseException)) {
        return left(e.error as BaseException);
      }
      return left(GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Either<BaseException, List<JiraIssueTypeResponse>>> getJiraIssueTypes(
      CommonParamsRequest request) async {
    try {
      final List<JiraIssueTypeResponse> response =
          await _jiraDataSource.getJiraIssueTypes(request);
      return right(response);
    } catch (e) {
      if ((e is DioException) && (e.error is BaseException)) {
        return left(e.error as BaseException);
      }
      return left(GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Either<BaseException, JiraProjectsResponse>> getJiraProjects(
      CommonParamsRequest request) async {
    try {
      final JiraProjectsResponse response =
          await _jiraDataSource.getJiraProjects(request);
      return right(response);
    } catch (e) {
      if ((e is DioException) && (e.error is BaseException)) {
        return left(e.error as BaseException);
      }
      return left(GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Either<BaseException, void>> addAttachmentToTicket(
      CommonParamsRequest params, FormData request) async {
    try {
      await _jiraDataSource.addAttachmentToTicket(params, request);
      return right(null);
    } catch (e) {
      if ((e is DioException) && (e.error is BaseException)) {
        return left(e.error as BaseException);
      }
      return left(GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Either<BaseException, void>> assignTicket(
      CommonParamsRequest params, AssignIssueRequest request) async {
    try {
      await _jiraDataSource.assignTicket(params, request);
      return right(null);
    } catch (e) {
      if ((e is DioException) && (e.error is BaseException)) {
        return left(e.error as BaseException);
      }
      return left(GeneralException(MyConstants.somethingWentWrong));
    }
  }

  @override
  Future<Either<BaseException, CreateJiraIssueResponse>> createJiraTicket(
      CommonParamsRequest params, CreateJiraIssueRequest request) async {
    try {
      final CreateJiraIssueResponse response =
          await _jiraDataSource.createJiraTicket(params, request);
      return right(response);
    } catch (e) {
      if ((e is DioException) && (e.error is BaseException)) {
        return left(e.error as BaseException);
      }
      return left(GeneralException(MyConstants.somethingWentWrong));
    }
  }
}
