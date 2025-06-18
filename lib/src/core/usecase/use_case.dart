import 'package:dartz/dartz.dart';
import 'package:shake_n_report/src/core/exceptions/exceptions.dart';

abstract class UseCase<T, P> {
  Future<Either<BaseException, T>> call(P reqParams);
}
