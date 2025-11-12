import 'package:shake_n_report/src/core/result/result.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_project_response.dart';
import 'package:shake_n_report/src/data/repositories/jira_repositories_impl.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class GetJiraProjectsUseCase
    extends UseCase<JiraProjectsResponse, CommonParamsRequest> {
  static final GetJiraProjectsUseCase _instance = GetJiraProjectsUseCase._internal();
  static GetJiraProjectsUseCase get instance => _instance;

  final JiraRepository jiraRepository;

  GetJiraProjectsUseCase._internal({
    JiraRepository? jiraRepository,
  }) : jiraRepository = jiraRepository ?? JiraRepositoriesImpl.instance;

  @override
  Future<Result<JiraProjectsResponse>> call(
          CommonParamsRequest reqParams) =>
      jiraRepository.getJiraProjects(reqParams);
}
