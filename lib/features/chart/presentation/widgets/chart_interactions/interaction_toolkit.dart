import 'package:flutter/material.dart';
import '../../../domain/entities/candle.dart';
import '../../widgets/chart_core/candlestick_chart_canvas.dart';

typedef OnTapCallback = void Function(Candle? hitCandle);

/// ===============================
/// Gesture Interaction Toolkit
/// ===============================

class ChartTouchOverlay extends StatefulWidget {
  final List<Candle> candles;
  final Widget child;
  final OnTapCallback onTap;
  const ChartTouchOverlay({
    required this.candles,
    required this.child,
    required this.onTap,
  });

  @override
  _ChartTouchOverlayState createState() => _ChartTouchOverlayState();
}

class _ChartTouchOverlayState extends State<ChartTouchOverlay> {
  Offset? _position;
  Candle? _hitCandle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        // Reset zoom/scroll
        // (يمكنك إرسال Event للـBloc لكي يعيد محاور الشاشة)
      },
      onLongPressStart: (details) {
        _updateHit(details.localPosition);
      },
      onLongPressMoveUpdate: (details) {
        _updateHit(details.localPosition);
      },
      onTapUp: (details) {
        _updateHit(details.localPosition);
      },
      child: Stack(
        children: [
          widget.child,
          if (_position != null && _hitCandle != null)
            Positioned(
              left: _position!.dx,
              top: _position!.dy - 40,
              child: _TooltipBox(candle: _hitCandle!),
            ),
        ],
      ),
    );
  }

  void _updateHit(Offset pos) {
    Candle? found;
    if (widget.candles.isNotEmpty) {
      double barWidth = MediaQuery.of(context).size.width /
          widget.candles.length;
      int index = (pos.dx / barWidth).floor();
      if (index >= 0 && index < widget.candles.length) {
        found = widget.candles[index];
      }
    }
    setState(() {
      _position = pos;
      _hitCandle = found;
    });
    widget.onTap(found);
  }
}

class _TooltipBox extends StatelessWidget {
  final Candle candle;
  const _TooltipBox({required this.candle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Time: \${candle.time}", style: TextStyle(color: Colors.white)),
          Text("O: \${candle.open}", style: TextStyle(color: Colors.white)),
          Text("H: \${candle.high}", style: TextStyle(color: Colors.white)),
          Text("L: \${candle.low}", style: TextStyle(color: Colors.white)),
          Text("C: \${candle.close}", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
