import 'package:dartz/dartz.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_issue_type_response.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class GetProjectIssueTypeUseCase
    extends UseCase<List<JiraIssueTypeResponse>, CommonParamsRequest> {
  final JiraRepository jiraRepository;

  GetProjectIssueTypeUseCase(this.jiraRepository);

  @override
  Future<Either<BaseException, List<JiraIssueTypeResponse>>> call(
          CommonParamsRequest reqParams) =>
      jiraRepository.getJiraIssueTypes(reqParams);
}
