abstract class AppError {
  String get message;
}

class NetworkError implements AppError {
  @override
  String get message => "No internet connection";
}

class ServerError implements AppError {
  final String details;
  ServerError(this.details);

  @override
  String get message => "Server error: $details";
}

class TimeoutError implements AppError {
  @override
  String get message => "Request timed out. Please try again.";
}

class InvalidCredentialsError implements AppError {
  @override
  String get message => "Invalid credentials. Please check your API Token and Account ID.";
}

class UnknownError implements AppError {
  @override
  String get message => "Something went wrong. Please retry.";
}
