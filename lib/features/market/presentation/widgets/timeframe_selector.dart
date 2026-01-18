import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_event.dart';

class TimeframeSelector extends StatefulWidget {
  final List<String> frames;

  const TimeframeSelector({required this.frames});

  @override
  _TimeframeSelectorState createState() => _TimeframeSelectorState();
}

class _TimeframeSelectorState extends State<TimeframeSelector> {
  String selected = "M1";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.frames.map((f) {
          final isSelected = f == selected;
          return GestureDetector(
            onTap: () {
              setState(() => selected = f);
              context.read<ChartBloc>().add(ChangeTimeframe(f));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  f,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
