import 'package:dartz/dartz.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_project_response.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class GetJiraProjectsUseCase
    extends UseCase<JiraProjectsResponse, CommonParamsRequest> {
  final JiraRepository jiraRepository;

  GetJiraProjectsUseCase(this.jiraRepository);

  @override
  Future<Either<BaseException, JiraProjectsResponse>> call(
          CommonParamsRequest reqParams) =>
      jiraRepository.getJiraProjects(reqParams);
}
