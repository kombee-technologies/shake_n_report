import 'package:shake_n_report/src/core/networks/http_client_wrapper.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';
import 'package:shake_n_report/src/data/data_source/remote_data_source/jira_data_source/jira_data_source.dart';
import 'package:shake_n_report/src/data/repositories/jira_repositories_impl.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/add_attachment_to_ticket_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/assign_user_to_ticket_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/create_jira_ticket_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_access_token_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_accessible_resource_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_assignable_user_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_jira_projects_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_project_issue_type_use_case.dart';

/// Initialize dependency injection by ensuring all singletons are initialized.
/// Since all classes now use singleton pattern, this method ensures
/// proper initialization order by accessing instances in dependency order.
Future<void> initDI() async {
  // Initialize in dependency order to ensure proper setup
  // Accessing instances ensures they are created in the correct order
  LocalStorage.instance;
  HttpClientWrapper.instance;
  JiraDataSourceImpl.instance;
  JiraRepositoriesImpl.instance;
  GetAccessTokenUseCase.instance;
  GetAccessibleResourceUseCase.instance;
  GetJiraProjectsUseCase.instance;
  GetProjectIssueTypeUseCase.instance;
  GetAssignableUserUseCase.instance;
  CreateJiraTicketUseCase.instance;
  AssignUserToTicketUseCase.instance;
  AddAttachmentToTicketUseCase.instance;
}
