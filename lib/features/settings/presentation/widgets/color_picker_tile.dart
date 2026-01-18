import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerTile extends StatelessWidget {
  final String title;
  final Color current;
  final ValueChanged<Color> onColorChanged;

  ColorPickerTile({
    required this.title,
    required this.current,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: CircleAvatar(backgroundColor: current),
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("اختر اللون"),
          content: BlockPicker(
            pickerColor: current,
            onColorChanged: onColorChanged,
          ),
        ),
      ),
    );
  }
}
