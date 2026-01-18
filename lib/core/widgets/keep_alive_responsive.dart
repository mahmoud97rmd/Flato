import 'package:flutter/widgets.dart';

class KeepAliveResponsive extends StatefulWidget {
  final Widget child;
  KeepAliveResponsive({required this.child});

  @override
  _KeepAliveResponsiveState createState() => _KeepAliveResponsiveState();
}

class _KeepAliveResponsiveState extends State<KeepAliveResponsive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
