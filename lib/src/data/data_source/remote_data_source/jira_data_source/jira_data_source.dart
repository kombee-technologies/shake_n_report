import 'package:http/http.dart' as http;
import 'package:shake_n_report/src/core/networks/api_end_points.dart';
import 'package:shake_n_report/src/core/networks/api_keys.dart';
import 'package:shake_n_report/src/core/networks/http_client_wrapper.dart';
import 'package:shake_n_report/src/core/networks/http_response.dart';
import 'package:shake_n_report/src/core/networks/multipart_helper.dart';
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

  Future<List<JiraIssueTypeResponse>> getJiraIssueTypes(
      CommonParamsRequest request);

  Future<List<JiraAssignableUsersResponse>> getJiraAssignableUsers(
      CommonParamsRequest request);

  Future<CreateJiraIssueResponse> createJiraTicket(
      CommonParamsRequest params, CreateJiraIssueRequest request);

  Future<void> assignTicket(
      CommonParamsRequest params, AssignIssueRequest request);

  Future<void> addAttachmentToTicket(
      CommonParamsRequest params, List<String> filePaths);
}

class JiraDataSourceImpl implements JiraDataSource {
  static final JiraDataSourceImpl _instance = JiraDataSourceImpl._internal();
  static JiraDataSourceImpl get instance => _instance;

  final HttpClientWrapper _httpClient;

  final LocalStorage _localStorage;

  JiraDataSourceImpl._internal({
    HttpClientWrapper? httpClient,
    LocalStorage? localStorage,
  })  : _httpClient = httpClient ?? HttpClientWrapper.instance,
        _localStorage = localStorage ?? LocalStorage.instance;

  @override
  Future<AccessTokenResponse> getAccessToken(
      GetAccessTokenRequest request) async {
    final HttpResponse<Map<String, dynamic>> response = await _httpClient.post<Map<String, dynamic>>(
      ApiEndPoints.oAuthTokenJira,
      data: request.toJson(),
      headers: <String, String>{
        ApiKeys.contentType: ApiKeys.applicationXWwwFormUrlencoded,
      },
    );
    return AccessTokenResponse.fromJson(response.data ?? <String, dynamic>{});
  }

  @override
  Future<List<AccessibleResourcesResponse>> getAccessibleResources() async {
    final String accessToken =
        await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    final HttpResponse<List<dynamic>> response = await _httpClient.get<List<dynamic>>(
      ApiEndPoints.getAccessibleResourcesJira,
      headers: <String, String>{
        ApiKeys.contentType: ApiKeys.applicationXWwwFormUrlencoded,
        ApiKeys.accept: ApiKeys.applicationJson,
        ApiKeys.authorization: 'Bearer $accessToken',
      },
    );
    return accessibleResourcesResponseFromJson(response.data ?? <dynamic>[]);
  }

  @override
  Future<List<JiraAssignableUsersResponse>> getJiraAssignableUsers(
      CommonParamsRequest request) async {
    final String accessToken =
        await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    final HttpResponse<List<dynamic>> response =
        await _httpClient.get<List<dynamic>>(
      ApiEndPoints.getAssignableUsersJira(
          request.cloudId ?? '', request.projectKey ?? ''),
      headers: <String, String>{
        ApiKeys.contentType: ApiKeys.applicationXWwwFormUrlencoded,
        ApiKeys.accept: ApiKeys.applicationJson,
        ApiKeys.authorization: 'Bearer $accessToken',
      },
    );
    return jiraAssignableUsersResponseFromMap(response.data ?? <dynamic>[]);
  }

  @override
  Future<List<JiraIssueTypeResponse>> getJiraIssueTypes(
      CommonParamsRequest request) async {
    final String accessToken =
        await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    final HttpResponse<List<dynamic>> response =
        await _httpClient.get<List<dynamic>>(
      ApiEndPoints.getJiraProjectIssueType(
          request.cloudId ?? '', request.projectId ?? ''),
      headers: <String, String>{
        ApiKeys.contentType: ApiKeys.applicationXWwwFormUrlencoded,
        ApiKeys.accept: ApiKeys.applicationJson,
        ApiKeys.authorization: 'Bearer $accessToken',
      },
    );

    return jiraIssueTypeResponseFromMap(response.data ?? <dynamic>[]);
  }

  @override
  Future<JiraProjectsResponse> getJiraProjects(
      CommonParamsRequest request) async {
    final String accessToken =
        await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    final HttpResponse<Map<String, dynamic>> response =
        await _httpClient.get<Map<String, dynamic>>(
      ApiEndPoints.getJiraProjects(request.cloudId ?? ''),
      headers: <String, String>{
        ApiKeys.contentType: ApiKeys.applicationXWwwFormUrlencoded,
        ApiKeys.accept: ApiKeys.applicationJson,
        ApiKeys.authorization: 'Bearer $accessToken',
      },
    );

    return JiraProjectsResponse.fromMap(response.data ?? <String, dynamic>{});
  }

  @override
  Future<CreateJiraIssueResponse> createJiraTicket(
      CommonParamsRequest params, CreateJiraIssueRequest request) async {
    final String accessToken =
        await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    final HttpResponse<Map<String, dynamic>> response =
        await _httpClient.post<Map<String, dynamic>>(
      ApiEndPoints.createIssueJira(params.cloudId ?? ''),
      data: request.toMap(),
      headers: <String, String>{
        ApiKeys.contentType: ApiKeys.applicationJson,
        ApiKeys.accept: ApiKeys.applicationJson,
        ApiKeys.authorization: 'Bearer $accessToken',
      },
    );

    return CreateJiraIssueResponse.fromMap(
        response.data ?? <String, dynamic>{});
  }

  @override
  Future<void> addAttachmentToTicket(
      CommonParamsRequest params, List<String> filePaths) async {
    final String accessToken =
        await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    // Convert file paths to MultipartFile objects
    // Jira API expects files under the 'file' key
    final List<http.MultipartFile> files = await MultipartHelper.filesFromPaths(
      'file',
      filePaths,
    );

    await _httpClient.postMultipart<List<dynamic>>(
      ApiEndPoints.attachFileJira(params.cloudId ?? '', params.issueKey ?? ''),
      files: files,
      headers: <String, String>{
        ApiKeys.xAtlassianToken: ApiKeys.noCheck,
        ApiKeys.authorization: 'Bearer $accessToken',
        ApiKeys.accept: ApiKeys.applicationJson,
      },
    );
  }

  @override
  Future<void> assignTicket(
      CommonParamsRequest params, AssignIssueRequest request) async {
    final String accessToken =
        await _localStorage.getStringData(LocalStorageKeys.jiraAccessToken);

    await _httpClient.put<dynamic>(
      ApiEndPoints.assignIssueJira(params.cloudId ?? '', params.issueKey ?? ''),
      data: request.toMap(),
      headers: <String, String>{
        ApiKeys.contentType: ApiKeys.applicationJson,
        ApiKeys.accept: ApiKeys.applicationJson,
        ApiKeys.authorization: 'Bearer $accessToken',
      },
    );
  }
}
