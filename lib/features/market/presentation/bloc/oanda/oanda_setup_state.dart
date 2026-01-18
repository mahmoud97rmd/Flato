abstract class OandaSetupState {}

class OandaInitial extends OandaSetupState {}

class OandaLoading extends OandaSetupState {}

class OandaConnected extends OandaSetupState {}

class OandaTokenExpired extends OandaSetupState {}

class OandaError extends OandaSetupState {
  final String message;
  OandaError(this.message);
}

class OandaLoggedOut extends OandaSetupState {}
