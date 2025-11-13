part of 'jira_management_cubit.dart';

class JiraManagementState {
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JiraManagementState &&
          runtimeType == other.runtimeType &&
          selectedProject == other.selectedProject &&
          projectItem == other.projectItem &&
          _listEquals(projects, other.projects) &&
          isProjectLoading == other.isProjectLoading &&
          errorMessage == other.errorMessage &&
          _listEquals(issueTypes, other.issueTypes) &&
          isIssueTypeLoading == other.isIssueTypeLoading &&
          issueTypeErrorMessage == other.issueTypeErrorMessage &&
          selectedIssueTypeID == other.selectedIssueTypeID &&
          _listEquals(assignableUsers, other.assignableUsers) &&
          isAssignableUsersLoading == other.isAssignableUsersLoading &&
          assignableUsersErrorMessage == other.assignableUsersErrorMessage &&
          selectedAssignerAccID == other.selectedAssignerAccID &&
          _listEquals(attachments, other.attachments) &&
          isSubmitting == other.isSubmitting &&
          createJiraIssueResponse == other.createJiraIssueResponse;

  @override
  int get hashCode => Object.hash(
        selectedProject,
        projectItem,
        projects,
        isProjectLoading,
        errorMessage,
        issueTypes,
        isIssueTypeLoading,
        issueTypeErrorMessage,
        selectedIssueTypeID,
        assignableUsers,
        isAssignableUsersLoading,
        assignableUsersErrorMessage,
        selectedAssignerAccID,
        attachments,
        isSubmitting,
        createJiraIssueResponse,
      );

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) {
      return b == null;
    }
    if (b == null || a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

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
        isAssignableUsersLoading:
            isAssignableUsersLoading ?? this.isAssignableUsersLoading,
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
}
