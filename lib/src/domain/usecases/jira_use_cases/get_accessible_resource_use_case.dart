import 'package:dartz/dartz.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/no_params.dart';
import 'package:shake_n_report/src/data/models/jira/response/accessible_resource_response.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class GetAccessibleResourceUseCase
    extends UseCase<List<AccessibleResourcesResponse>, NoParams> {
  final JiraRepository _jiraRepository;

  GetAccessibleResourceUseCase(this._jiraRepository);

  @override
  Future<Either<BaseException, List<AccessibleResourcesResponse>>> call(
          NoParams reqParams) =>
      _jiraRepository.getAccessibleResources();
}
