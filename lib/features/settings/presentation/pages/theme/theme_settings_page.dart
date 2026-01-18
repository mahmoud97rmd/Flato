import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_event.dart';
import '../../../domain/theme/app_theme.dart';

class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeBloc>().state.theme;

    return Scaffold(
      appBar: AppBar(title: Text("Theme Settings")),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Text("Theme Mode"),
          DropdownButton<AppThemeMode>(
            value: theme.mode,
            items: AppThemeMode.values
                .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                .toList(),
            onChanged: (m) {
              context.read<ThemeBloc>().add(ChangeThemeMode(m!));
            },
          ),
          Divider(),
          Text("Candle Colors"),
          ListTile(
            title: Text("Bull Candle"),
            trailing: CircleAvatar(backgroundColor: theme.bullCandle),
            onTap: () {},
          ),
          ListTile(
            title: Text("Bear Candle"),
            trailing: CircleAvatar(backgroundColor: theme.bearCandle),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

void _pickColor(BuildContext context, Color currentColor, Function(Color) onColorChanged) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Pick a Color"),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: currentColor,
          onColorChanged: onColorChanged,
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text("Done"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    ),
  );
}

void _updateIndicatorColor(BuildContext context, String id, Color color) {
  final theme = context.read<ThemeBloc>().state.theme;
  final updatedTheme = AppTheme(
    mode: theme.mode,
    bullCandle: theme.bullCandle,
    bearCandle: theme.bearCandle,
    emaColor: id == "ema" ? color : theme.emaColor,
    stochColor: id == "stoch" ? color : theme.stochColor,
    rsiColor: id == "rsi" ? color : theme.rsiColor,
    bollingerColor: id == "bollinger" ? color : theme.bollingerColor,
  );
  context.read<ThemeBloc>().add(UpdateThemeColors(updatedTheme));
}
