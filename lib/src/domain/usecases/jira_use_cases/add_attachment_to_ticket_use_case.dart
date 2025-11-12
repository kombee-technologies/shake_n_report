import 'package:shake_n_report/src/core/result/result.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/data/repositories/jira_repositories_impl.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class AddAttachmentToTicketUseCase
    extends UseCase<void, AddAttachmentToTicketRequest> {
  static final AddAttachmentToTicketUseCase _instance = AddAttachmentToTicketUseCase._internal();
  static AddAttachmentToTicketUseCase get instance => _instance;

  final JiraRepository jiraRepository;

  AddAttachmentToTicketUseCase._internal({
    JiraRepository? jiraRepository,
  }) : jiraRepository = jiraRepository ?? JiraRepositoriesImpl.instance;

  @override
  Future<Result<void>> call(
          AddAttachmentToTicketRequest reqParams) =>
      jiraRepository.addAttachmentToTicket(
          reqParams.commonParamsRequest, reqParams.filePaths);
}

class AddAttachmentToTicketRequest {
  final CommonParamsRequest commonParamsRequest;
  final List<String> filePaths;

  AddAttachmentToTicketRequest({
    required this.commonParamsRequest,
    required this.filePaths,
  });
}
