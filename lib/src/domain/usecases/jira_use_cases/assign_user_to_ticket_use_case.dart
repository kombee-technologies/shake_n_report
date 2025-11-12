import 'package:shake_n_report/src/core/result/result.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/assign_issue_request.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/repositories/jira_repositories_impl.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class AssignUserToTicketUseCase extends UseCase<void, AssignTicketRequest> {
  static final AssignUserToTicketUseCase _instance = AssignUserToTicketUseCase._internal();
  static AssignUserToTicketUseCase get instance => _instance;

  final JiraRepository jiraRepository;

  AssignUserToTicketUseCase._internal({
    JiraRepository? jiraRepository,
  }) : jiraRepository = jiraRepository ?? JiraRepositoriesImpl.instance;

  @override
  Future<Result<void>> call(AssignTicketRequest reqParams) =>
      jiraRepository.assignTicket(
          reqParams.commonParamsRequest, reqParams.assignIssueRequest);
}

class AssignTicketRequest {
  final CommonParamsRequest commonParamsRequest;
  final AssignIssueRequest assignIssueRequest;

  AssignTicketRequest(
      {required this.commonParamsRequest, required this.assignIssueRequest});
}
