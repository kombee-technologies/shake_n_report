import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shake_n_report/shake_to_report.dart';
import 'package:shake_n_report/src/core/constants/my_constants.dart';
import 'package:shake_n_report/src/core/di.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
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

  final LocalStorage _localStorage = getIt<LocalStorage>();

  final GetAccessibleResourceUseCase getAccessibleResourcesUseCase = getIt<GetAccessibleResourceUseCase>();

  final GetAccessTokenUseCase getAccessTokenUseCase = getIt<GetAccessTokenUseCase>();

  final GetJiraProjectsUseCase getJiraProjectsUseCase = getIt<GetJiraProjectsUseCase>();

  final GetProjectIssueTypeUseCase getProjectIssueTypeUseCase = getIt<GetProjectIssueTypeUseCase>();

  final GetAssignableUserUseCase getAssignableUserUseCase = getIt<GetAssignableUserUseCase>();

  final CreateJiraTicketUseCase createJiraTicketUseCase = getIt<CreateJiraTicketUseCase>();

  final AssignUserToTicketUseCase assignUserToTicketUseCase = getIt<AssignUserToTicketUseCase>();

  final AddAttachmentToTicketUseCase addAttachmentToTicketUseCase = getIt<AddAttachmentToTicketUseCase>();

  Future<void> getAccessToken(String code) async {
    final GetAccessTokenRequest request = GetAccessTokenRequest(
      code: code,
      grantType: MyConstants.authorizationCode,
      clientId: ShakeToReportPlugin.instance.jiraConfig?.clientId ?? '',
      clientSecret: ShakeToReportPlugin.instance.jiraConfig?.clientSecret ?? '',
      redirectUri: ShakeToReportPlugin.instance.jiraConfig?.redirectUrl ?? '',
    );
    final BuildContext? context = ShakeToReportPlugin.instance.navigatorKey.currentContext;
    final Either<BaseException, AccessTokenResponse> accessToken = await getAccessTokenUseCase.call(request);
    accessToken.fold(
      (BaseException error) {
        Utility.showSnackbar(msg: error.message, bannerStyle: BannerStyle.error);
        emit(JiraManagementInitial());
        if (context != null && context.mounted) {
          context.read<ShakeDetectionCubit>().resetState();
          Navigator.of(context).pop();
        }
      },
      (AccessTokenResponse token) async {
        Utility.showSnackbar(msg: 'Access token received successfully', bannerStyle: BannerStyle.success);
        await _localStorage.clear();
        await _localStorage.setStringData(LocalStorageKeys.jiraAccessToken, token.accessToken ?? '');
        await _localStorage.setStringData(LocalStorageKeys.jiraRefreshToken, token.refreshToken ?? '');
        if (context != null && context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => const ProjectSelectionScreen(),
            ),
          );
        }
      },
    );
  }

  void selectProject(AccessibleResourcesResponse? project, ProjectItem? projectItem) {
    emit(state.copyWith(selectedProject: project, projectItem: projectItem));
  }

  /// call get accessible resources use case here
  Future<void> getAccessibleResources() async {
    emit(state.copyWith(isProjectLoading: true));

    final Either<BaseException, List<AccessibleResourcesResponse>> resources =
        await getAccessibleResourcesUseCase.call(NoParams());
    resources.fold(
      (BaseException error) {
        emit(state.copyWith(isProjectLoading: false, errorMessage: error.message));
      },
      (List<AccessibleResourcesResponse> projects) {
        emit(state.copyWith(projects: projects, isProjectLoading: false));
      },
    );
  }

  Future<void> getProjectsForResource(String resourceId) async {
    // Ensure there are projects in the state to update
    if (state.projects == null) {
      // Optionally, log or handle this case, e.g., emit an error state
      return;
    }

    final int index = state.projects!.indexWhere((AccessibleResourcesResponse item) => item.id == resourceId);

    // Ensure the resource was found in the list
    if (index == -1) {
      // Optionally, log or handle this case
      return;
    }

    final Either<BaseException, JiraProjectsResponse> resourcesResult =
        await getJiraProjectsUseCase.call(CommonParamsRequest(cloudId: resourceId));

    // Create a new list from the existing projects to ensure immutability
    final List<AccessibleResourcesResponse> updatedProjectResources =
        List<AccessibleResourcesResponse>.from(state.projects!);
    final AccessibleResourcesResponse resourceToUpdate = updatedProjectResources[index];

    resourcesResult.fold(
      (BaseException error) {
        updatedProjectResources[index] = resourceToUpdate.copyWith(errorStr: error.message);
        emit(state.copyWith(projects: updatedProjectResources));
      },
      (JiraProjectsResponse projectsRes) {
        updatedProjectResources[index] = resourceToUpdate.copyWith(projects: projectsRes.values);
        emit(state.copyWith(projects: updatedProjectResources));
      },
    );
  }

  Future<void> getProjectIssueTypes() async {
    emit(state.copyWith(isIssueTypeLoading: true));
    final String? cloudId = state.selectedProject?.id;
    final String? projectId = state.projectItem?.id;

    final Either<BaseException, List<JiraIssueTypeResponse>> issueTypesResult =
        await getProjectIssueTypeUseCase.call(CommonParamsRequest(cloudId: cloudId, projectId: projectId));

    issueTypesResult.fold(
      (BaseException error) {
        emit(state.copyWith(isIssueTypeLoading: false, errorMessage: error.message));
      },
      (List<JiraIssueTypeResponse> issueTypes) {
        emit(state.copyWith(issueTypes: issueTypes, isIssueTypeLoading: false));
      },
    );
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
      attachments: (attachments.isEmpty) ? <XFile>[] : (state.attachments + attachments),
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

    final Either<BaseException, List<JiraAssignableUsersResponse>> assignableUsersResult =
        await getAssignableUserUseCase.call(CommonParamsRequest(cloudId: cloudId, projectKey: projectKey));

    assignableUsersResult.fold(
      (BaseException error) {
        emit(state.copyWith(isAssignableUsersLoading: false, errorMessage: error.message));
        Utility.showSnackbar(msg: error.message, bannerStyle: BannerStyle.error);
      },
      (List<JiraAssignableUsersResponse> users) {
        // Filter out inactive users if necessary, or handle as per your requirements
        final List<JiraAssignableUsersResponse> activeUsers =
            users.where((JiraAssignableUsersResponse user) => user.active == true).toList();
        emit(state.copyWith(assignableUsers: activeUsers, isAssignableUsersLoading: false));
      },
    );
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
        msg: 'Project, or Issue Type not selected. Please select them before submitting.',
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

    final CreateJiraTicketRequest createTicketFullRequest = CreateJiraTicketRequest(
      commonParamsRequest: CommonParamsRequest(cloudId: cloudId),
      createJiraIssueRequest: issueRequestBody,
    );

    final Either<BaseException, CreateJiraIssueResponse> createTicketResult =
        await createJiraTicketUseCase.call(createTicketFullRequest);

    CreateJiraIssueResponse? ticketResponse;

    await createTicketResult.fold(
      (BaseException error) async {
        if (error is UnauthorizedException) {
          final BuildContext? context = ShakeToReportPlugin.instance.navigatorKey.currentContext;
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
      },
      (CreateJiraIssueResponse response) async {
        ticketResponse = response;
        // emit(state.copyWith(
        //   createJiraIssueResponse: response,
        //   selectedIssueTypeID: state.selectedIssueTypeID,
        //   selectedAssignerAccID: state.selectedAssignerAccID,
        // )); // Store response early
        Utility.showSnackbar(msg: 'Ticket created successfully!', bannerStyle: BannerStyle.success);

        final String issueKey = response.key ?? '';

        // 2. Assign User (if selected)
        if (state.selectedAssignerAccID != null && state.selectedAssignerAccID?.accountId != null) {
          final AssignIssueRequest assignRequestBody =
              AssignIssueRequest(accountId: state.selectedAssignerAccID?.accountId);
          final AssignTicketRequest assignTicketFullRequest = AssignTicketRequest(
            commonParamsRequest: CommonParamsRequest(cloudId: cloudId, issueKey: issueKey),
            assignIssueRequest: assignRequestBody,
          );

          final Either<BaseException, void> assignResult =
              await assignUserToTicketUseCase.call(assignTicketFullRequest);
          assignResult.fold(
            (BaseException error) {
              Utility.showSnackbar(
                  msg: 'Ticket created, but failed to assign user: ${error.message}', bannerStyle: BannerStyle.warning);
              // Continue to attachments even if assignment fails
            },
            (_) {
              Utility.showSnackbar(
                  msg: 'User ${state.selectedAssignerAccID?.displayName} assigned successfully.',
                  bannerStyle: BannerStyle.success);
            },
          );
        }

        // 3. Add Attachments (if any)
        if (state.attachments.isNotEmpty) {
          final List<dio.MultipartFile> multipartFiles = <dio.MultipartFile>[];
          for (final XFile file in state.attachments) {
            multipartFiles.add(await dio.MultipartFile.fromFile(file.path, filename: file.name));
          }
          // Jira API expects files under the 'file' key, and it can handle multiple files with the same key.
          final dio.FormData formData = dio.FormData.fromMap(<String, dynamic>{'file': multipartFiles});

          final AddAttachmentToTicketRequest addAttachmentFullRequest = AddAttachmentToTicketRequest(
            commonParamsRequest: CommonParamsRequest(cloudId: cloudId, issueKey: issueKey),
            formData: formData,
          );

          final Either<BaseException, void> attachmentResult =
              await addAttachmentToTicketUseCase.call(addAttachmentFullRequest);
          attachmentResult.fold(
            (BaseException error) {
              Utility.showSnackbar(
                  msg: 'Ticket created, but failed to add attachments: ${error.message}',
                  bannerStyle: BannerStyle.warning);
            },
            (_) {
              Utility.showSnackbar(msg: 'Attachments added successfully.', bannerStyle: BannerStyle.success);
            },
          );
        }
      },
    );

    // Finalize state
    if (ticketResponse != null) {
      // Success path completed (ticket created, assignment/attachments attempted)
      emit(state.copyWith(isSubmitting: false, createJiraIssueResponse: ticketResponse));
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
