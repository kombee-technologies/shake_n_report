import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shake_n_report/shake_n_report.dart';
import 'package:shake_n_report/src/core/constants/my_constants.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/core/result/result.dart';
import 'package:shake_n_report/src/core/utils/utility.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage_keys.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/models/jira/request/create_jira_issue_request.dart';
import 'package:shake_n_report/src/data/models/jira/request/get_access_token_request.dart';
import 'package:shake_n_report/src/data/models/jira/request/assign_issue_request.dart';
import 'package:shake_n_report/src/data/models/jira/request/no_params.dart';
import 'package:shake_n_report/src/data/models/jira/response/access_token_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/accessible_resource_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/create_jira_issue_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_assignable_users_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_issue_type_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_project_response.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/add_attachment_to_ticket_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/assign_user_to_ticket_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/create_jira_ticket_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_access_token_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_accessible_resource_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_assignable_user_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_jira_projects_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_project_issue_type_use_case.dart';
import 'package:shake_n_report/src/presentation/pages/jira_project_selection/project_selection.dart';
import 'package:shake_n_report/src/presentation/state_management/shake_detection_bloc/shake_detection_cubit.dart';

part 'jira_management_state.dart';

class JiraManagementCubit extends Cubit<JiraManagementState> {
  JiraManagementCubit() : super(JiraManagementInitial());

  final LocalStorage _localStorage = LocalStorage.instance;

  final GetAccessibleResourceUseCase getAccessibleResourcesUseCase =
      GetAccessibleResourceUseCase.instance;

  final GetAccessTokenUseCase getAccessTokenUseCase =
      GetAccessTokenUseCase.instance;

  final GetJiraProjectsUseCase getJiraProjectsUseCase =
      GetJiraProjectsUseCase.instance;

  final GetProjectIssueTypeUseCase getProjectIssueTypeUseCase =
      GetProjectIssueTypeUseCase.instance;

  final GetAssignableUserUseCase getAssignableUserUseCase =
      GetAssignableUserUseCase.instance;

  final CreateJiraTicketUseCase createJiraTicketUseCase =
      CreateJiraTicketUseCase.instance;

  final AssignUserToTicketUseCase assignUserToTicketUseCase =
      AssignUserToTicketUseCase.instance;

  final AddAttachmentToTicketUseCase addAttachmentToTicketUseCase =
      AddAttachmentToTicketUseCase.instance;

  Future<void> getAccessToken(String code) async {
    final GetAccessTokenRequest request = GetAccessTokenRequest(
      code: code,
      grantType: MyConstants.authorizationCode,
      clientId: ShakeNReportPlugin.instance.jiraConfig?.clientId ?? '',
      clientSecret: ShakeNReportPlugin.instance.jiraConfig?.clientSecret ?? '',
      redirectUri: ShakeNReportPlugin.instance.jiraConfig?.redirectUrl ?? '',
    );
    final BuildContext? context =
        ShakeNReportPlugin.instance.navigatorKey.currentContext;
    final Result<AccessTokenResponse> accessToken =
        await getAccessTokenUseCase.call(request);

    switch (accessToken) {
      case Failure<AccessTokenResponse>(exception: final BaseException error):
        Utility.showSnackbar(
            msg: error.message, bannerStyle: BannerStyle.error);
        emit(JiraManagementInitial());
        if (context != null && context.mounted) {
          context.read<ShakeDetectionCubit>().resetState();
          Navigator.of(context).pop();
        }
      case Success<AccessTokenResponse>(value: final AccessTokenResponse token):
        Utility.showSnackbar(
            msg: 'Access token received successfully',
            bannerStyle: BannerStyle.success);
        await _localStorage.clear();
        await _localStorage.setStringData(
            LocalStorageKeys.jiraAccessToken, token.accessToken ?? '');
        await _localStorage.setStringData(
            LocalStorageKeys.jiraRefreshToken, token.refreshToken ?? '');
        if (context != null && context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => const ProjectSelectionScreen(),
            ),
          );
        }
    }
  }

  void selectProject(
      AccessibleResourcesResponse? project, ProjectItem? projectItem) {
    emit(state.copyWith(selectedProject: project, projectItem: projectItem));
  }

  /// call get accessible resources use case here
  Future<void> getAccessibleResources() async {
    emit(state.copyWith(isProjectLoading: true));

    final Result<List<AccessibleResourcesResponse>> resources =
        await getAccessibleResourcesUseCase.call(NoParams());

    switch (resources) {
      case Failure<List<AccessibleResourcesResponse>>(
          exception: final BaseException error
        ):
        emit(state.copyWith(
            isProjectLoading: false, errorMessage: error.message));
      case Success<List<AccessibleResourcesResponse>>(
          value: final List<AccessibleResourcesResponse> projects
        ):
        emit(state.copyWith(projects: projects, isProjectLoading: false));
    }
  }

  Future<void> getProjectsForResource(String resourceId) async {
    // Ensure there are projects in the state to update
    if (state.projects == null) {
      // Optionally, log or handle this case, e.g., emit an error state
      return;
    }

    final int index = state.projects!.indexWhere(
        (AccessibleResourcesResponse item) => item.id == resourceId);

    // Ensure the resource was found in the list
    if (index == -1) {
      // Optionally, log or handle this case
      return;
    }

    final Result<JiraProjectsResponse> resourcesResult =
        await getJiraProjectsUseCase
            .call(CommonParamsRequest(cloudId: resourceId));

    // Create a new list from the existing projects to ensure immutability
    final List<AccessibleResourcesResponse> updatedProjectResources =
        List<AccessibleResourcesResponse>.from(state.projects!);
    final AccessibleResourcesResponse resourceToUpdate =
        updatedProjectResources[index];

    switch (resourcesResult) {
      case Failure<JiraProjectsResponse>(exception: final BaseException error):
        updatedProjectResources[index] =
            resourceToUpdate.copyWith(errorStr: error.message);
        emit(state.copyWith(projects: updatedProjectResources));
      case Success<JiraProjectsResponse>(
          value: final JiraProjectsResponse projectsRes
        ):
        updatedProjectResources[index] =
            resourceToUpdate.copyWith(projects: projectsRes.values);
        emit(state.copyWith(projects: updatedProjectResources));
    }
  }

  Future<void> getProjectIssueTypes() async {
    emit(state.copyWith(isIssueTypeLoading: true));
    final String? cloudId = state.selectedProject?.id;
    final String? projectId = state.projectItem?.id;

    final Result<List<JiraIssueTypeResponse>> issueTypesResult =
        await getProjectIssueTypeUseCase
            .call(CommonParamsRequest(cloudId: cloudId, projectId: projectId));

    switch (issueTypesResult) {
      case Failure<List<JiraIssueTypeResponse>>(
          exception: final BaseException error
        ):
        emit(state.copyWith(
            isIssueTypeLoading: false, errorMessage: error.message));
      case Success<List<JiraIssueTypeResponse>>(
          value: final List<JiraIssueTypeResponse> issueTypes
        ):
        emit(state.copyWith(issueTypes: issueTypes, isIssueTypeLoading: false));
    }
  }

  void setSelectedIssueType(JiraIssueTypeResponse? issueType) {
    emit(state.copyWith(
      selectedIssueTypeID: issueType,
      selectedAssignerAccID: state.selectedAssignerAccID,
    ));
  }

  void setSelectedAssigner(JiraAssignableUsersResponse? assignee) {
    emit(state.copyWith(
      selectedAssignerAccID: assignee,
      selectedIssueTypeID: state.selectedIssueTypeID,
    ));
  }

  void onAddAttachments(List<XFile> attachments) {
    emit(state.copyWith(
      attachments:
          (attachments.isEmpty) ? <XFile>[] : (state.attachments + attachments),
      selectedAssignerAccID: state.selectedAssignerAccID,
      selectedIssueTypeID: state.selectedIssueTypeID,
    ));
  }

  void onRemoveAttachment(int index) {
    final List<XFile> attachments = state.attachments..removeAt(index);
    onAddAttachments(attachments);
  }

  Future<void> getAssignableUsers() async {
    emit(state.copyWith(isAssignableUsersLoading: true));
    final String? cloudId = state.selectedProject?.id;
    final String? projectKey = state.projectItem?.key;

    final Result<List<JiraAssignableUsersResponse>> assignableUsersResult =
        await getAssignableUserUseCase.call(
            CommonParamsRequest(cloudId: cloudId, projectKey: projectKey));

    switch (assignableUsersResult) {
      case Failure<List<JiraAssignableUsersResponse>>(
          exception: final BaseException error
        ):
        emit(state.copyWith(
            isAssignableUsersLoading: false, errorMessage: error.message));
        Utility.showSnackbar(
            msg: error.message, bannerStyle: BannerStyle.error);
      case Success<List<JiraAssignableUsersResponse>>(
          value: final List<JiraAssignableUsersResponse> users
        ):
        // Filter out inactive users if necessary, or handle as per your requirements
        final List<JiraAssignableUsersResponse> activeUsers = users
            .where((JiraAssignableUsersResponse user) => user.active == true)
            .toList();
        emit(state.copyWith(
            assignableUsers: activeUsers, isAssignableUsersLoading: false));
    }
  }

  void resetState() {
    emit(JiraManagementInitial());
  }

  Future<void> submitReport({
    required String title,
    required String description,
  }) async {
    if (state.selectedProject == null ||
        state.projectItem == null ||
        state.selectedIssueTypeID == null ||
        state.selectedAssignerAccID == null) {
      Utility.showSnackbar(
        msg:
            'Project, or Issue Type not selected. Please select them before submitting.',
        bannerStyle: BannerStyle.error,
      );
      return;
    }

    emit(state.copyWith(
      isSubmitting: true,
      selectedIssueTypeID: state.selectedIssueTypeID,
      selectedAssignerAccID: state.selectedAssignerAccID,
    ));

    final String cloudId = state.selectedProject?.id ?? '';
    final String projectId = state.projectItem?.id ?? '';
    final String issueTypeId = state.selectedIssueTypeID?.id ?? '';

    // 1. Create Jira Ticket
    final CreateJiraIssueRequest issueRequestBody = CreateJiraIssueRequest(
      fields: Fields(
        summary: title,
        project: Issuetype(id: projectId),
        issuetype: Issuetype(id: issueTypeId),
        description: Description(
          type: 'doc',
          version: 1,
          content: <DescriptionContent>[
            DescriptionContent(
              type: 'paragraph',
              content: <ContentContent>[
                ContentContent(type: 'text', text: description),
              ],
            ),
          ],
        ),
      ),
    );

    final CreateJiraTicketRequest createTicketFullRequest =
        CreateJiraTicketRequest(
      commonParamsRequest: CommonParamsRequest(cloudId: cloudId),
      createJiraIssueRequest: issueRequestBody,
    );

    final Result<CreateJiraIssueResponse> createTicketResult =
        await createJiraTicketUseCase.call(createTicketFullRequest);

    CreateJiraIssueResponse? ticketResponse;

    switch (createTicketResult) {
      case Failure<CreateJiraIssueResponse>(
          exception: final BaseException error
        ):
        if (error is UnauthorizedException) {
          final BuildContext? context =
              ShakeNReportPlugin.instance.navigatorKey.currentContext;
          if (context != null && context.mounted) {
            context.read<JiraManagementCubit>().resetState();
            context.read<ShakeDetectionCubit>().resetState();
            Navigator.of(context).pop();
            Utility.showSnackbar(
              msg: 'Session expired. Please re-authenticate.',
              bannerStyle: BannerStyle.error,
            );
          }
        } else {
          emit(state.copyWith(
            isSubmitting: false,
            errorMessage: error.message,
            selectedIssueTypeID: state.selectedIssueTypeID,
            selectedAssignerAccID: state.selectedAssignerAccID,
          ));
        }
      case Success<CreateJiraIssueResponse>(
          value: final CreateJiraIssueResponse response
        ):
        ticketResponse = response;
        // emit(state.copyWith(
        //   createJiraIssueResponse: response,
        //   selectedIssueTypeID: state.selectedIssueTypeID,
        //   selectedAssignerAccID: state.selectedAssignerAccID,
        // )); // Store response early
        Utility.showSnackbar(
            msg: 'Ticket created successfully!',
            bannerStyle: BannerStyle.success);

        final String issueKey = response.key ?? '';

        // 2. Assign User (if selected)
        if (state.selectedAssignerAccID != null &&
            state.selectedAssignerAccID?.accountId != null) {
          final AssignIssueRequest assignRequestBody = AssignIssueRequest(
              accountId: state.selectedAssignerAccID?.accountId);
          final AssignTicketRequest assignTicketFullRequest =
              AssignTicketRequest(
            commonParamsRequest:
                CommonParamsRequest(cloudId: cloudId, issueKey: issueKey),
            assignIssueRequest: assignRequestBody,
          );

          final Result<void> assignResult =
              await assignUserToTicketUseCase.call(assignTicketFullRequest);
          switch (assignResult) {
            case Failure<void>(exception: final BaseException error):
              Utility.showSnackbar(
                  msg:
                      'Ticket created, but failed to assign user: ${error.message}',
                  bannerStyle: BannerStyle.warning);
            // Continue to attachments even if assignment fails
            case Success<void>():
              Utility.showSnackbar(
                  msg:
                      'User ${state.selectedAssignerAccID?.displayName} assigned successfully.',
                  bannerStyle: BannerStyle.success);
          }
        }

        // 3. Add Attachments (if any)
        if (state.attachments.isNotEmpty) {
          // Extract file paths from XFile objects
          final List<String> filePaths =
              state.attachments.map((XFile file) => file.path).toList();

          final AddAttachmentToTicketRequest addAttachmentFullRequest =
              AddAttachmentToTicketRequest(
            commonParamsRequest:
                CommonParamsRequest(cloudId: cloudId, issueKey: issueKey),
            filePaths: filePaths,
          );

          final Result<void> attachmentResult =
              await addAttachmentToTicketUseCase.call(addAttachmentFullRequest);
          switch (attachmentResult) {
            case Failure<void>(exception: final BaseException error):
              Utility.showSnackbar(
                  msg:
                      'Ticket created, but failed to add attachments: ${error.message}',
                  bannerStyle: BannerStyle.warning);
            case Success<void>():
              Utility.showSnackbar(
                  msg: 'Attachments added successfully.',
                  bannerStyle: BannerStyle.success);
          }
        }
    }

    // Finalize state
    if (ticketResponse != null) {
      // Success path completed (ticket created, assignment/attachments attempted)
      emit(state.copyWith(
          isSubmitting: false, createJiraIssueResponse: ticketResponse));
    } else {
      // Failure in ticket creation itself
      emit(state.copyWith(
        isSubmitting: false,
        selectedIssueTypeID: state.selectedIssueTypeID,
        selectedAssignerAccID: state.selectedAssignerAccID,
      )); // Error message already set
    }
  }
}
