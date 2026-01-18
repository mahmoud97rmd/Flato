import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../strategy_script/data/script_storage.dart';

class ScriptEditorPage extends StatefulWidget {
  @override
  _ScriptEditorPageState createState() => _ScriptEditorPageState();
}

class _ScriptEditorPageState extends State<ScriptEditorPage> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ScriptStorage().load().then((value) {
      if (value != null) setState(() => controller.text = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Strategy Script")),
      body: Column(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScriptStorage().save(controller.text);
              Navigator.pop(context);
            },
            child: Text("Save Script"),
          ),
        ],
      ),
    );
  }
}
