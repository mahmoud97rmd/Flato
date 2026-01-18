import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/audit/audit_bloc.dart';
import '../../bloc/audit/audit_event.dart';
import '../../bloc/audit/audit_state.dart';

class AuditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audit Trail")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.read<AuditBloc>().add(LoadAuditLogs()),
            child: Text("Refresh Logs"),
          ),
          Expanded(
            child: BlocBuilder<AuditBloc, AuditState>(
              builder: (context, state) {
                if (state is AuditLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is AuditLoaded) {
                  if (state.logs.isEmpty) return Center(child: Text("No logs"));
                  return ListView.builder(
                    itemCount: state.logs.length,
                    itemBuilder: (ctx, i) {
                      final log = state.logs[i];
                      return ListTile(
                        title: Text(log.message),
                        subtitle: Text(log.timestamp.toString()),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
