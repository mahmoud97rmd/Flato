import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/strategy/presentation/bloc/strategy_builder_bloc.dart';
import 'package:your_app/features/strategy/presentation/bloc/strategy_builder_event.dart';
import 'package:your_app/features/strategy/presentation/bloc/strategy_builder_state.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../core/models/strategy_graph.dart';
import '../../../mocks.dart';

class MockStrategyStorage extends Mock implements StrategyStorage {}

void main() {
  late MockStrategyStorage mockStorage;

  setUp(() {
    mockStorage = MockStrategyStorage();
  });

  blocTest<StrategyBuilderBloc, StrategyBuilderState>(
    'emits BuilderLoaded on AddBlock',
    build: () => StrategyBuilderBloc(mockStorage),
    act: (bloc) =>
        bloc.add(AddBlock(id: 'b1', type: 'ema', params: {})),
    expect: () => [isA<BuilderLoaded>()],
  );
}
