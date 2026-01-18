import 'package:flutter/material.dart';

class DrawingOverlay extends StatelessWidget {
  final List<List<Offset>> trendlines;
  final List<double> horizontalLines;

  DrawingOverlay({
    required this.trendlines,
    required this.horizontalLines,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OverlayPainter(
        trendlines: trendlines,
        horizontalLines: horizontalLines,
      ),
      child: Container(),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final List<List<Offset>> trendlines;
  final List<double> horizontalLines;

  _OverlayPainter({
    required this.trendlines,
    required this.horizontalLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2;

    final paintHLine = Paint()
      ..color = Colors.orange
      ..strokeWidth = 1;

    // Trendlines
    for (var line in trendlines) {
      if (line.length >= 2) {
        canvas.drawLine(line[0], line[1], paintLine);
      }
    }

    // Horizontal lines
    for (var y in horizontalLines) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paintHLine,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter old) {
    return old.trendlines != trendlines ||
        old.horizontalLines != horizontalLines;
  }
}
