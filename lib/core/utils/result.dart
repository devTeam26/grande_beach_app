import '../errors/failure.dart';

/// Result of an operation that can either succeed with [T] or fail with a [Failure].
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    final self = this;
    if (self is Success<T>) return onSuccess(self.data);
    if (self is ResultFailure<T>) return onFailure(self.failure);
    throw StateError('Unknown Result subtype');
  }
}

class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);

  final Failure failure;
}
