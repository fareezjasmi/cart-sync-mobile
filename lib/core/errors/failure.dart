abstract class Failure {
  final String? errorCode;
  final String errorMessage;
  Failure({this.errorCode, required this.errorMessage});
}

class ServerError extends Failure {
  ServerError({super.errorCode, required super.errorMessage});
}

class NetworkError extends Failure {
  NetworkError() : super(errorMessage: 'No internet connection');
}

class UnauthorizedError extends Failure {
  UnauthorizedError() : super(errorMessage: 'Unauthorized. Please login again.');
}
