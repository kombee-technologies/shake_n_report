part of 'jira_management_cubit.dart';

class JiraManagementState extends Equatable {
  final AccessibleResourcesResponse? selectedProject;
  final ProjectItem? projectItem;
  final List<AccessibleResourcesResponse>? projects;
  final bool isProjectLoading;
  final String? errorMessage;

  final List<JiraIssueTypeResponse>? issueTypes;
  final bool? isIssueTypeLoading;
  final String? issueTypeErrorMessage;
  final JiraIssueTypeResponse? selectedIssueTypeID;

  final List<JiraAssignableUsersResponse>? assignableUsers;
  final bool? isAssignableUsersLoading;
  final String? assignableUsersErrorMessage;
  final JiraAssignableUsersResponse? selectedAssignerAccID;

  final List<XFile> attachments;

  final bool isSubmitting;

  final CreateJiraIssueResponse? createJiraIssueResponse;

  JiraManagementState({
    this.selectedProject,
    this.projectItem,
    this.isProjectLoading = false,
    this.projects = const <AccessibleResourcesResponse>[],
    this.errorMessage,
    this.issueTypes,
    this.isIssueTypeLoading = false,
    this.assignableUsers,
    this.isAssignableUsersLoading = false,
    this.selectedIssueTypeID,
    this.selectedAssignerAccID,
    this.issueTypeErrorMessage,
    this.assignableUsersErrorMessage,
    this.isSubmitting = false,
    this.attachments = const <XFile>[],
    this.createJiraIssueResponse,
  });

  @override
  List<Object?> get props => <Object?>[
        selectedProject,
        projectItem,
        isProjectLoading,
        projects,
        errorMessage,
        issueTypes,
        isIssueTypeLoading,
        assignableUsers,
        isAssignableUsersLoading,
        issueTypeErrorMessage,
        assignableUsersErrorMessage,
        selectedIssueTypeID,
        selectedAssignerAccID,
        isSubmitting,
        attachments,
        createJiraIssueResponse,
      ];

  /// copy with method generate
  JiraManagementState copyWith({
    AccessibleResourcesResponse? selectedProject,
    ProjectItem? projectItem,
    bool? isProjectLoading,
    List<AccessibleResourcesResponse>? projects,
    String? errorMessage,
    List<JiraIssueTypeResponse>? issueTypes,
    bool? isIssueTypeLoading,
    List<JiraAssignableUsersResponse>? assignableUsers,
    bool? isAssignableUsersLoading,
    JiraIssueTypeResponse? selectedIssueTypeID,
    JiraAssignableUsersResponse? selectedAssignerAccID,
    String? issueTypeErrorMessage,
    String? assignableUsersErrorMessage,
    bool? isSubmitting,
    List<XFile>? attachments,
    CreateJiraIssueResponse? createJiraIssueResponse,
  }) =>
      JiraManagementState(
        selectedProject: selectedProject ?? this.selectedProject,
        projectItem: projectItem ?? this.projectItem,
        isProjectLoading: isProjectLoading ?? this.isProjectLoading,
        projects: projects ?? this.projects,
        errorMessage: errorMessage,
        issueTypes: issueTypes ?? this.issueTypes,
        isIssueTypeLoading: isIssueTypeLoading ?? this.isIssueTypeLoading,
        assignableUsers: assignableUsers ?? this.assignableUsers,
        isAssignableUsersLoading: isAssignableUsersLoading ?? this.isAssignableUsersLoading,
        selectedIssueTypeID: selectedIssueTypeID,
        selectedAssignerAccID: selectedAssignerAccID,
        issueTypeErrorMessage: issueTypeErrorMessage,
        assignableUsersErrorMessage: assignableUsersErrorMessage,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        attachments: attachments ?? this.attachments,
        createJiraIssueResponse: createJiraIssueResponse,
      );
}

final class JiraManagementInitial extends JiraManagementState {
  JiraManagementInitial()
      : super(
            selectedProject: null,
            projectItem: null,
            isProjectLoading: false,
            projects: const <AccessibleResourcesResponse>[],
            errorMessage: null);

  @override
  List<Object?> get props => <Object?>[super.props];
}
