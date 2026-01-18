import 'package:flutter/material.dart';

class ReplayControls extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;

  ReplayControls({
    required this.onPlay,
    required this.onPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: Icon(Icons.play_arrow), onPressed: onPlay),
        IconButton(icon: Icon(Icons.pause), onPressed: onPause),
        IconButton(icon: Icon(Icons.stop), onPressed: onStop),
      ],
    );
  }
}
