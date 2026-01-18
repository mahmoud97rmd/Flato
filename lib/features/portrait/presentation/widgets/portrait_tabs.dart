import 'package:flutter/material.dart';

class PortraitTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PortraitTabBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Chart"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Indicators"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alerts"),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
