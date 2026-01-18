import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/oanda/oanda_setup_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/oanda/oanda_setup_event.dart';
import 'package:your_app/features/market/presentation/bloc/oanda/oanda_setup_state.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks.dart';

class MockSecureStorage extends Mock implements OandaSecureStorage {}
class MockRestClient extends Mock implements RestClient {}

void main() {
  group('OandaSetupBloc', () {
    late MockSecureStorage mockStorage;

    setUp(() {
      mockStorage = MockSecureStorage();
    });

    blocTest<OandaSetupBloc, OandaSetupState>(
      'emits Connected when valid credentials',
      build: () {
        return OandaSetupBloc(storage: mockStorage, baseUrl: 'https://fake');
      },
      act: (bloc) => bloc.add(SubmitOandaCredentials(token: 't', accountId: 'id')),
      expect: () => [isA<OandaLoading>(), isA<OandaConnected>()],
    );
  });
}
