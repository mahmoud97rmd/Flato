import 'package:flutter/material.dart';
import '../../../../core/storage/app_preferences.dart';

class ThemeSwitch extends StatefulWidget {
  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    AppPreferences.loadThemeMode().then((d) {
      setState(() => _isDark = d);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text("Dark Mode"),
      value: _isDark,
      onChanged: (v) {
        AppPreferences.saveThemeMode(v);
        setState(() => _isDark = v);
      },
    );
  }
}
