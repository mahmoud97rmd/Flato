import 'package:flutter/material.dart';
import '../../../domain/alerts/smart/smart_alert.dart';

class SmartAlertDialog extends StatefulWidget {
  final String symbol;
  SmartAlertDialog({required this.symbol});

  @override
  _SmartAlertDialogState createState() => _SmartAlertDialogState();
}

class _SmartAlertDialogState extends State<SmartAlertDialog> {
  SmartAlertType _selectedType = SmartAlertType.rsiBelow;
  final TextEditingController _threshold = TextEditingController();
  final TextEditingController _duration = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Smart Alert"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<SmartAlertType>(
            value: _selectedType,
            items: SmartAlertType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.toString())))
                .toList(),
            onChanged: (v) => setState(() => _selectedType = v!),
          ),
          TextField(
            controller: _threshold,
            decoration: InputDecoration(labelText: "Threshold"),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          TextField(
            controller: _duration,
            decoration: InputDecoration(labelText: "Duration (seconds)"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final th = double.tryParse(_threshold.text) ?? 0;
            final dur = int.tryParse(_duration.text) ?? 0;
            final condition = SmartAlertCondition(
              type: _selectedType,
              durationSeconds: dur,
              threshold: th,
            );
            final alert = SmartAlert(instrument: widget.symbol, condition: condition);
            Navigator.pop(context, alert);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
