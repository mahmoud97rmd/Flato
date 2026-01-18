import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  const ResponsiveWidget({
    required this.mobile,
    required this.tablet,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) return tablet;
          return mobile;
        },
      );
}
