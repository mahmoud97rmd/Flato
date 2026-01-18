import 'package:flutter/widgets.dart';

class KeepAliveChart extends StatefulWidget {
  final Widget child;

  KeepAliveChart({required this.child});

  @override
  _KeepAliveChartState createState() => _KeepAliveChartState();
}

class _KeepAliveChartState extends State<KeepAliveChart>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
