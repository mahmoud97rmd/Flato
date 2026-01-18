import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../market/presentation/bloc/smart_alert/smart_alert_bloc.dart';
import '../../../market/presentation/bloc/smart_alert/smart_alert_state.dart';

class AlertsPortraitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartAlertBloc, SmartAlertState>(
      builder: (context, state) {
        if (state is SmartAlertUpdated) {
          return ListView.builder(
            itemCount: state.alerts.length,
            itemBuilder: (ctx, i) {
              final alert = state.alerts[i];
              return ListTile(
                title: Text(alert.condition.type.toString()),
                subtitle: Text("Active"),
              );
            },
          );
        }
        return Center(child: Text("No Alerts"));
      },
    );
  }
}
