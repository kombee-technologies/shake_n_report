import 'package:shake_n_report/src/core/result/result.dart';

abstract class UseCase<T, P> {
  Future<Result<T>> call(P reqParams);
}
