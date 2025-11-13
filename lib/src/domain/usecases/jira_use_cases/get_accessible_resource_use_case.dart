import 'package:shake_n_report/src/core/result/result.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/no_params.dart';
import 'package:shake_n_report/src/data/models/jira/response/accessible_resource_response.dart';
import 'package:shake_n_report/src/data/repositories/jira_repositories_impl.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class GetAccessibleResourceUseCase
    extends UseCase<List<AccessibleResourcesResponse>, NoParams> {
  static final GetAccessibleResourceUseCase _instance =
      GetAccessibleResourceUseCase._internal();
  static GetAccessibleResourceUseCase get instance => _instance;

  final JiraRepository _jiraRepository;

  GetAccessibleResourceUseCase._internal({
    JiraRepository? jiraRepository,
  }) : _jiraRepository = jiraRepository ?? JiraRepositoriesImpl.instance;

  @override
  Future<Result<List<AccessibleResourcesResponse>>> call(NoParams reqParams) =>
      _jiraRepository.getAccessibleResources();
}
