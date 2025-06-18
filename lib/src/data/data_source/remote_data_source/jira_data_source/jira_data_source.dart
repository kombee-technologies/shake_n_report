import 'package:dio/dio.dart';
import 'package:shake_n_report/src/core/networks/api_end_points.dart';
import 'package:shake_n_report/src/core/networks/api_keys.dart';
import 'package:shake_n_report/src/core/networks/dio_factory.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage_keys.dart';
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

abstract class JiraDataSource {
  Future<AccessTokenResponse> getAccessToken(GetAccessTokenRequest request);

  Future<List<AccessibleResourcesResponse>> getAccessibleResources();

  Future<JiraProjectsResponse> getJiraProjects(CommonParamsRequest request);

  Future<List<JiraIssueTypeResponse>> getJiraIssueTypes(CommonParamsRequest request);

  Future<List<JiraAssignableUsersResponse>> getJiraAssignableUsers(CommonParamsRequest request);

  Future<CreateJiraIssueResponse> createJiraTicket(CommonParamsRequest params, CreateJiraIssueRequest request);

  Future<void> assignTicket(CommonParamsRequest params, AssignIssueRequest request);

  Future<void> addAttachmentToTicket(CommonParamsRequest params, FormData request);
}

class JiraDataSourceImpl implements JiraDataSource {
  final DioFactory _dioFactory;

  final LocalStorage _localStorage;

  JiraDataSourceImpl(this._dioFactory, this._localStorage);

  @override
  Future<AccessTokenResponse> getAccessToken(GetAccessTokenRequest request) async {
    final Response<Map<String, dynamic>> response = await _dioFactory.shared.post<Map<String, dynamic>>(
      ApiEndPoints.oAuthTokenJira,
      data: request.toJson(),
    );
    return AccessTokenResponse.fromJson(response.data ?? <String, dynamic>{});
  }

  @override
  Future<List<AccessibleResourcesResponse>> getAccessibleResources() async {
    final String accessToken = await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    final Response<List<dynamic>> response = await _dioFactory.shared.get<List<dynamic>>(
      ApiEndPoints.getAccessibleResourcesJira,
      options: Options(
        headers: <String, dynamic>{
          ApiKeys.contentType: ApiKeys.applicationXWwwFormUrlencoded,
          ApiKeys.accept: ApiKeys.applicationJson,
          ApiKeys.authorization: 'Bearer $accessToken',
        },
      ),
    );
    return accessibleResourcesResponseFromJson(response.data ?? <dynamic>[]);
  }

  @override
  Future<List<JiraAssignableUsersResponse>> getJiraAssignableUsers(CommonParamsRequest request) async {
    final String accessToken = await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    final Response<List<dynamic>> response = await _dioFactory.shared.get<List<dynamic>>(
      ApiEndPoints.getAssignableUsersJira(request.cloudId ?? '', request.projectKey ?? ''),
      options: Options(
        headers: <String, dynamic>{
          ApiKeys.contentType: ApiKeys.applicationXWwwFormUrlencoded,
          ApiKeys.accept: ApiKeys.applicationJson,
          ApiKeys.authorization: 'Bearer $accessToken',
        },
      ),
    );
    return jiraAssignableUsersResponseFromMap(response.data ?? <dynamic>[]);
  }

  @override
  Future<List<JiraIssueTypeResponse>> getJiraIssueTypes(CommonParamsRequest request) async {
    final String accessToken = await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    final Response<List<dynamic>> response = await _dioFactory.shared.get<List<dynamic>>(
      ApiEndPoints.getJiraProjectIssueType(request.cloudId ?? '', request.projectId ?? ''),
      options: Options(
        headers: <String, dynamic>{
          ApiKeys.contentType: ApiKeys.applicationXWwwFormUrlencoded,
          ApiKeys.accept: ApiKeys.applicationJson,
          ApiKeys.authorization: 'Bearer $accessToken',
        },
      ),
    );

    return jiraIssueTypeResponseFromMap(response.data ?? <dynamic>[]);
  }

  @override
  Future<JiraProjectsResponse> getJiraProjects(CommonParamsRequest request) async {
    final String accessToken = await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    final Response<Map<String, dynamic>> response = await _dioFactory.shared.get<Map<String, dynamic>>(
      ApiEndPoints.getJiraProjects(request.cloudId ?? ''),
      options: Options(
        headers: <String, dynamic>{
          ApiKeys.contentType: ApiKeys.applicationXWwwFormUrlencoded,
          ApiKeys.accept: ApiKeys.applicationJson,
          ApiKeys.authorization: 'Bearer $accessToken',
        },
      ),
    );

    return JiraProjectsResponse.fromMap(response.data ?? <String, dynamic>{});
  }

  @override
  Future<CreateJiraIssueResponse> createJiraTicket(CommonParamsRequest params, CreateJiraIssueRequest request) async {
    final String accessToken = await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    final Response<Map<String, dynamic>> response = await _dioFactory.shared.post<Map<String, dynamic>>(
      ApiEndPoints.createIssueJira(params.cloudId ?? ''),
      data: request.toMap(),
      options: Options(
        headers: <String, dynamic>{
          ApiKeys.contentType: ApiKeys.applicationJson,
          ApiKeys.accept: ApiKeys.applicationJson,
          ApiKeys.authorization: 'Bearer $accessToken',
        },
      ),
    );

    return CreateJiraIssueResponse.fromMap(response.data ?? <String, dynamic>{});
  }

  @override
  Future<void> addAttachmentToTicket(CommonParamsRequest params, FormData request) async {
    final String accessToken = await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    await _dioFactory.shared.post<List<dynamic>>(
      ApiEndPoints.attachFileJira(params.cloudId ?? '', params.issueKey ?? ''),
      data: request,
      options: Options(
        headers: <String, dynamic>{
          ApiKeys.xAtlassianToken: ApiKeys.noCheck,
          ApiKeys.authorization: 'Bearer $accessToken',
          ApiKeys.contentType: ApiKeys.multipartFormData,
          ApiKeys.accept: ApiKeys.applicationJson,
        },
      ),
    );
  }

  @override
  Future<void> assignTicket(CommonParamsRequest params, AssignIssueRequest request) async {
    final String accessToken = await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    await _dioFactory.shared.put<dynamic>(
      ApiEndPoints.assignIssueJira(params.cloudId ?? '', params.issueKey ?? ''),
      data: request.toMap(),
      options: Options(
        headers: <String, dynamic>{
          ApiKeys.contentType: ApiKeys.applicationJson,
          ApiKeys.accept: ApiKeys.applicationJson,
          ApiKeys.authorization: 'Bearer $accessToken',
        },
      ),
    );
  }
}
