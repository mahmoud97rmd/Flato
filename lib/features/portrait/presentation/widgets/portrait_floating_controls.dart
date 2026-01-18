import 'package:flutter/material.dart';
import '../../../replay/domain/entities/speed.dart';

class PortraitFloatingControls extends StatelessWidget {
  final Function() onZoomIn;
  final Function() onZoomOut;
  final Function(ReplaySpeed) onSpeedChange;

  const PortraitFloatingControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onSpeedChange,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: "zoomIn",
            mini: true,
            child: Icon(Icons.zoom_in),
            onPressed: onZoomIn,
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "zoomOut",
            mini: true,
            child: Icon(Icons.zoom_out),
            onPressed: onZoomOut,
          ),
          SizedBox(height: 8),
          PopupMenuButton<ReplaySpeed>(
            icon: Icon(Icons.speed),
            itemBuilder: (_) => ReplaySpeed.values
                .map((s) => PopupMenuItem(value: s, child: Text(s.name)))
                .toList(),
            onSelected: (speed) => onSpeedChange(speed),
          ),
        ],
      ),
    );
  }
}
