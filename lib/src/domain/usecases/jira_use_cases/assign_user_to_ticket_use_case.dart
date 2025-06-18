import 'package:dartz/dartz.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/assign_issue_request.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class AssignUserToTicketUseCase extends UseCase<void, AssignTicketRequest> {
  final JiraRepository jiraRepository;

  AssignUserToTicketUseCase(this.jiraRepository);

  @override
  Future<Either<BaseException, void>> call(AssignTicketRequest reqParams) =>
      jiraRepository.assignTicket(reqParams.commonParamsRequest, reqParams.assignIssueRequest);
}

class AssignTicketRequest {
  final CommonParamsRequest commonParamsRequest;
  final AssignIssueRequest assignIssueRequest;

  AssignTicketRequest({required this.commonParamsRequest, required this.assignIssueRequest});
}
