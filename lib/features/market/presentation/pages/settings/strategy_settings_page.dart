import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_event.dart';
import '../../bloc/settings/settings_state.dart';

class StrategySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Strategy Settings")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is SettingsLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is SettingsLoaded) {
              final config = state.config;
              final emaShortCtrl =
                  TextEditingController(text: config.emaShort.toString());
              final emaLongCtrl =
                  TextEditingController(text: config.emaLong.toString());
              final stochPeriodCtrl =
                  TextEditingController(text: config.stochPeriod.toString());
              final stochSmoothKCtrl =
                  TextEditingController(text: config.stochSmoothK.toString());
              final stochSmoothDCtrl =
                  TextEditingController(text: config.stochSmoothD.toString());
              final slCtrl =
                  TextEditingController(text: config.stopLossPct.toString());
              final tpCtrl =
                  TextEditingController(text: config.takeProfitPct.toString());

              return ListView(
                children: [
                  TextField(
                    controller: emaShortCtrl,
                    decoration: InputDecoration(labelText: "EMA Short"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: emaLongCtrl,
                    decoration: InputDecoration(labelText: "EMA Long"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: stochPeriodCtrl,
                    decoration: InputDecoration(labelText: "Stoch Period"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: stochSmoothKCtrl,
                    decoration: InputDecoration(labelText: "Stoch Smooth K"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: stochSmoothDCtrl,
                    decoration: InputDecoration(labelText: "Stoch Smooth D"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: slCtrl,
                    decoration: InputDecoration(labelText: "Stop Loss %"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  TextField(
                    controller: tpCtrl,
                    decoration: InputDecoration(labelText: "Take Profit %"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(
                            UpdateStrategySettings(
                              emaShort: int.parse(emaShortCtrl.text),
                              emaLong: int.parse(emaLongCtrl.text),
                              stochPeriod: int.parse(stochPeriodCtrl.text),
                              stochSmoothK: int.parse(stochSmoothKCtrl.text),
                              stochSmoothD: int.parse(stochSmoothDCtrl.text),
                              stopLossPct: double.parse(slCtrl.text),
                              takeProfitPct: double.parse(tpCtrl.text),
                            ),
                          );
                    },
                    child: Text("Save Settings"),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
