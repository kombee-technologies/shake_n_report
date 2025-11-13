import 'package:shake_n_report/src/core/exceptions/exceptions.dart';

/// A sealed class representing the result of an operation that can either
/// succeed with a value of type [T] or fail with a [BaseException].
///
/// This replaces the `Either` type from dartz package and uses Dart 3.0
/// sealed classes with pattern matching for type-safe error handling.
///
/// Example usage:
/// ```dart
/// final Result<String> result = await someOperation();
///
/// switch (result) {
///   case Success(value: final data):
///     print('Success: $data');
///   case Failure(exception: final error):
///     print('Error: ${error.message}');
/// }
/// ```
sealed class Result<T> {
  const Result();
}

/// Represents a successful result containing a value of type [T].
final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

/// Represents a failed result containing a [BaseException].
final class Failure<T> extends Result<T> {
  final BaseException exception;

  const Failure(this.exception);
}
