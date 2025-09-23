import 'package:dartz/dartz.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_assignable_users_response.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class GetAssignableUserUseCase
    extends UseCase<List<JiraAssignableUsersResponse>, CommonParamsRequest> {
  final JiraRepository jiraRepository;

  GetAssignableUserUseCase(this.jiraRepository);

  @override
  Future<Either<BaseException, List<JiraAssignableUsersResponse>>> call(
          CommonParamsRequest reqParams) =>
      jiraRepository.getJiraAssignableUsers(reqParams);
}
