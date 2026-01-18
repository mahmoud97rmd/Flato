abstract class OandaSetupEvent {}

class SubmitOandaCredentials extends OandaSetupEvent {
  final String token;
  final String accountId;

  SubmitOandaCredentials({
    required this.token,
    required this.accountId,
  });
}

class RetryConnection extends OandaSetupEvent {}

class LogoutOanda extends OandaSetupEvent {}
