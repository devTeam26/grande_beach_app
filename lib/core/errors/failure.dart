/// Base type for all domain/network failures returned through [Result].
sealed class Failure {
  const Failure(this.message);

  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fieldErrors});

  final Map<String, List<String>>? fieldErrors;
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
