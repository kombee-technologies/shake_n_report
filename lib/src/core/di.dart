import 'package:get_it/get_it.dart';
import 'package:shake_n_report/src/core/networks/dio_factory.dart';
import 'package:shake_n_report/src/data/data_source/local_data_source/local_storage.dart';
import 'package:shake_n_report/src/data/data_source/remote_data_source/jira_data_source/jira_data_source.dart';
import 'package:shake_n_report/src/data/repositories/jira_repositories_impl.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/add_attachment_to_ticket_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/assign_user_to_ticket_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/create_jira_ticket_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_access_token_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_accessible_resource_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_assignable_user_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_jira_projects_use_case.dart';
import 'package:shake_n_report/src/domain/usecases/jira_use_cases/get_project_issue_type_use_case.dart';
import 'package:toastification/toastification.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDI() async {
  getIt
    ..registerSingleton<LocalStorage>(LocalStorage())
    ..registerLazySingleton<DioFactory>(() => DioFactory())
    ..registerLazySingleton<Toastification>(() => Toastification())
    ..registerLazySingleton<JiraDataSource>(() => JiraDataSourceImpl(getIt(), getIt()))
    ..registerLazySingleton<JiraRepository>(() => JiraRepositoriesImpl(getIt()))
    ..registerLazySingleton<GetAccessTokenUseCase>(() => GetAccessTokenUseCase(getIt()))
    ..registerLazySingleton<GetAccessibleResourceUseCase>(() => GetAccessibleResourceUseCase(getIt()))
    ..registerLazySingleton<GetJiraProjectsUseCase>(() => GetJiraProjectsUseCase(getIt()))
    ..registerLazySingleton<GetProjectIssueTypeUseCase>(() => GetProjectIssueTypeUseCase(getIt()))
    ..registerLazySingleton<GetAssignableUserUseCase>(() => GetAssignableUserUseCase(getIt()))
    ..registerLazySingleton<CreateJiraTicketUseCase>(() => CreateJiraTicketUseCase(getIt()))
    ..registerLazySingleton<AssignUserToTicketUseCase>(() => AssignUserToTicketUseCase(getIt()))
    ..registerLazySingleton<AddAttachmentToTicketUseCase>(() => AddAttachmentToTicketUseCase(getIt()));
}
