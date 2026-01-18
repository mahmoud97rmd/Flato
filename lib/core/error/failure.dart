abstract class Failure {
  final String message;
  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String m) : super(m);
}

class AuthFailure extends Failure {
  AuthFailure(String m) : super(m);
}

class ParsingFailure extends Failure {
  ParsingFailure(String m) : super(m);
}

class UnknownFailure extends Failure {
  UnknownFailure(String m) : super(m);
}
