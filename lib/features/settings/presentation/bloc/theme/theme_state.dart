import '../../../domain/theme/app_theme.dart';

class ThemeState {
  final AppTheme theme;
  const ThemeState(this.theme);

  Map<String, dynamic> toJson() => theme.toJson();

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    return ThemeState(AppTheme.fromJson(json));
  }
}
