import 'package:flutter_bloc/flutter_bloc.dart';
import 'oanda_setup_event.dart';
import 'oanda_setup_state.dart';
import '../../../../core/storage/oanda/secure_storage.dart';
import '../../../../core/network/rest_client.dart';

class OandaSetupBloc extends Bloc<OandaSetupEvent, OandaSetupState> {
  final OandaSecureStorage storage;
  final String baseUrl;

  OandaSetupBloc({
    required this.storage,
    required this.baseUrl,
  }) : super(OandaInitial()) {
    on<SubmitOandaCredentials>(_onSubmit);
    on<RetryConnection>(_onRetry);
    on<LogoutOanda>(_onLogout);
  }

  Future<void> _onSubmit(SubmitOandaCredentials event, Emitter<OandaSetupState> emit) async {
    emit(OandaLoading());

    try {
      // store securely
      await storage.saveToken(event.token);
      await storage.saveAccountId(event.accountId);

      // test connection
      final rest = RestClient(event.token, baseUrl);
      final res = await rest.get('/v3/accounts/${event.accountId}');
      if (res.statusCode == 200) {
        emit(OandaConnected());
      } else if (res.statusCode == 401) {
        emit(OandaTokenExpired());
      } else {
        emit(OandaError('HTTP ${res.statusCode}'));
      }
    } catch (e) {
      emit(OandaError(e.toString()));
    }
  }

  Future<void> _onRetry(RetryConnection event, Emitter<OandaSetupState> emit) async {
    final token = await storage.loadToken();
    final accountId = await storage.loadAccountId();

    if (token == null || accountId == null) {
      return emit(OandaError('No credentials stored'));
    }

    add(SubmitOandaCredentials(token: token, accountId: accountId));
  }

  Future<void> _onLogout(LogoutOanda event, Emitter<OandaSetupState> emit) async {
    await storage.clearAll();
    emit(OandaLoggedOut());
  }
}
