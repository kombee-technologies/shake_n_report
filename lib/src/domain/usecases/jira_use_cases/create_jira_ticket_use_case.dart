import 'package:dartz/dartz.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/models/jira/request/create_jira_issue_request.dart';
import 'package:shake_n_report/src/data/models/jira/response/create_jira_issue_response.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class CreateJiraTicketUseCase
    extends UseCase<CreateJiraIssueResponse, CreateJiraTicketRequest> {
  final JiraRepository _jiraRepository;

  CreateJiraTicketUseCase(this._jiraRepository);

  @override
  Future<Either<BaseException, CreateJiraIssueResponse>> call(
          CreateJiraTicketRequest reqParams) =>
      _jiraRepository.createJiraTicket(
          reqParams.commonParamsRequest, reqParams.createJiraIssueRequest);
}

class CreateJiraTicketRequest {
  final CommonParamsRequest commonParamsRequest;
  final CreateJiraIssueRequest createJiraIssueRequest;

  CreateJiraTicketRequest(
      {required this.commonParamsRequest,
      required this.createJiraIssueRequest});
}
