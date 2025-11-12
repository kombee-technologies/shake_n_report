import 'package:shake_n_report/src/core/result/result.dart';
import 'package:shake_n_report/src/core/usecase/use_case.dart';
import 'package:shake_n_report/src/data/models/jira/request/get_access_token_request.dart';
import 'package:shake_n_report/src/data/models/jira/response/access_token_response.dart';
import 'package:shake_n_report/src/data/repositories/jira_repositories_impl.dart';
import 'package:shake_n_report/src/domain/repositories/jira_repository.dart';

class GetAccessTokenUseCase
    extends UseCase<AccessTokenResponse, GetAccessTokenRequest> {
  static final GetAccessTokenUseCase _instance = GetAccessTokenUseCase._internal();
  static GetAccessTokenUseCase get instance => _instance;

  final JiraRepository _jiraRepository;

  GetAccessTokenUseCase._internal({
    JiraRepository? jiraRepository,
  }) : _jiraRepository = jiraRepository ?? JiraRepositoriesImpl.instance;

  @override
  Future<Result<AccessTokenResponse>> call(
          GetAccessTokenRequest reqParams) =>
      _jiraRepository.getAccessToken(reqParams);
}
