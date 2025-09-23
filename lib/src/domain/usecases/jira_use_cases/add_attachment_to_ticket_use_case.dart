import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/common_params_request.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class AddAttachmentToTicketUseCase
    extends UseCase<void, AddAttachmentToTicketRequest> {
  final JiraRepository jiraRepository;

  AddAttachmentToTicketUseCase(this.jiraRepository);

  @override
  Future<Either<BaseException, void>> call(
          AddAttachmentToTicketRequest reqParams) =>
      jiraRepository.addAttachmentToTicket(
          reqParams.commonParamsRequest, reqParams.formData);
}

class AddAttachmentToTicketRequest {
  final CommonParamsRequest commonParamsRequest;
  final FormData formData;

  AddAttachmentToTicketRequest({
    required this.commonParamsRequest,
    required this.formData,
  });
}
