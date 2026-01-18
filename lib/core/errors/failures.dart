abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message): super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message): super(message);
}

class UnknownFailure extends Failure {
  UnknownFailure(): super("Unknown Error");
}
