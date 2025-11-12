import 'package:shake_n_report/src/core/result/result.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_issue_type_response.dart';
import 'package:shake_n_report/src/data/repositories/jira_repositories_impl.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class GetProjectIssueTypeUseCase
    extends UseCase<List<JiraIssueTypeResponse>, CommonParamsRequest> {
  static final GetProjectIssueTypeUseCase _instance = GetProjectIssueTypeUseCase._internal();
  static GetProjectIssueTypeUseCase get instance => _instance;

  final JiraRepository jiraRepository;

  GetProjectIssueTypeUseCase._internal({
    JiraRepository? jiraRepository,
  }) : jiraRepository = jiraRepository ?? JiraRepositoriesImpl.instance;

  @override
  Future<Result<List<JiraIssueTypeResponse>>> call(
          CommonParamsRequest reqParams) =>
      jiraRepository.getJiraIssueTypes(reqParams);
}
