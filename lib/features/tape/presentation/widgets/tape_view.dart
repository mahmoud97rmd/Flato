import 'package:flutter/material.dart';
import '../../domain/tape_event.dart';

class TapeView extends StatelessWidget {
  final List<TapeEvent> events;
  TapeView(this.events);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: events.map((e) =>
        ListTile(
          title: Text("${e.price} (${e.side})"),
          trailing: Text("${e.volume}"),
          subtitle: Text("${e.time.toIso8601String()}"),
        )).toList(),
    );
  }
}
