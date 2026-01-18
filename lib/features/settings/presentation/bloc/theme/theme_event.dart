import '../../../domain/theme/app_theme.dart';

abstract class ThemeEvent {}

class ChangeThemeMode extends ThemeEvent {
  final AppThemeMode mode;
  ChangeThemeMode(this.mode);
}

class UpdateThemeColors extends ThemeEvent {
  final AppTheme theme;
  UpdateThemeColors(this.theme);
}
