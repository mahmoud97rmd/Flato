import 'package:flutter/material.dart';

class StrategyDslEditor extends StatefulWidget {
  final String initial;
  final ValueChanged<String> onChanged;

  StrategyDslEditor({required this.initial, required this.onChanged});

  @override
  _StrategyDslEditorState createState() => _StrategyDslEditorState();
}

class _StrategyDslEditorState extends State<StrategyDslEditor> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      decoration: InputDecoration(labelText: "Strategy Expression"),
      onSubmitted: widget.onChanged,
    );
  }
}
