import 'package:dartz/dartz.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_assignable_users_response.dart';
import 'package:shake_n_report/src/data/repositories/jira_repositories_impl.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class GetAssignableUserUseCase
    extends UseCase<List<JiraAssignableUsersResponse>, CommonParamsRequest> {
  static final GetAssignableUserUseCase _instance = GetAssignableUserUseCase._internal();
  static GetAssignableUserUseCase get instance => _instance;

  final JiraRepository jiraRepository;

  GetAssignableUserUseCase._internal({
    JiraRepository? jiraRepository,
  }) : jiraRepository = jiraRepository ?? JiraRepositoriesImpl.instance;

  @override
  Future<Either<BaseException, List<JiraAssignableUsersResponse>>> call(
          CommonParamsRequest reqParams) =>
      jiraRepository.getJiraAssignableUsers(reqParams);
}
