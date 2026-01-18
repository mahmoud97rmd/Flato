import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../data/theme/theme_repository.dart';
import '../../../domain/theme/app_theme.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  final ThemeRepository repo;

  ThemeBloc(this.repo)
      : super(ThemeState(repo.loadTheme())) {
    on<ChangeThemeMode>((event, emit) {
      final updated = AppTheme(
        mode: event.mode,
        bullCandle: state.theme.bullCandle,
        bearCandle: state.theme.bearCandle,
        emaColor: state.theme.emaColor,
        rsiColor: state.theme.rsiColor,
        macdColor: state.theme.macdColor,
        bollingerColor: state.theme.bollingerColor,
      );
      repo.saveTheme(updated);
      emit(ThemeState(updated));
    });

    on<UpdateThemeColors>((event, emit) {
      repo.saveTheme(event.theme);
      emit(ThemeState(event.theme));
    });
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) =>
      ThemeState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ThemeState state) => state.toJson();
}
