import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/logging/audit_logger.dart';
import '../../../../features/market/presentation/bloc/oanda/oanda_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            child: Text("Fetch OANDA Instruments"),
            onPressed: () => context.read<OandaBloc>().add(LoadInstruments()),
          ),
        ),

        Expanded(child: BlocBuilder<OandaBloc, OandaState>(
          builder: (context, state) {
            if (state is OandaLoading)
              return Center(child: CircularProgressIndicator());
            if (state is OandaLoaded)
              return ListView.builder(
                itemCount: state.instruments.length,
                itemBuilder: (c, i) => ListTile(
                  title: Text(state.instruments[i]),
                  onTap: () {
                    AuditLogger.log("InstrumentSelected", state.instruments[i]);
                    Navigator.pushNamed(context, "/chart", arguments: state.instruments[i]);
                  },
                ),
              );
            if (state is OandaError)
              return Center(child: Text("Error: \${state.message}"));
            return Center(child: Text("No Data Loaded"));
          },
        )),

        Divider(),
        Padding(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            child: Text("Settings"),
            onPressed: () => Navigator.pushNamed(context, "/settings"),
          ),
        ),
      ]),
    );
  }
}
