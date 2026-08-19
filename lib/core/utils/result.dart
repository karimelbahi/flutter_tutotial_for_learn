import '../errors/failures.dart';

/// Wraps the outcome of a repository or use case call.
///
/// Why not throw exceptions to the Cubit?
/// - Keeps error handling explicit: Cubit checks `result.isSuccess`
/// - Domain/presentation never catches HTTP or JSON errors directly
///
/// Flow:
///   DataSource throws Exception → Repository catches → returns Result.failure
///   DataSource succeeds       → Repository returns Result.success(data)
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  T? get dataOrNull => switch (this) {
        Success(value: final value) => value,
        Error() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success() => null,
        Error(failure: final failure) => failure,
      };
}

/// Successful result carrying [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

/// Failed result carrying a domain [failure].
final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}
