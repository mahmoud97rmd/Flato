import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplay({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 12),
          if (onRetry != null)
            ElevatedButton.icon(
              icon: Icon(Icons.refresh),
              label: Text("Retry"),
              onPressed: onRetry,
            ),
        ],
      ),
    );
  }
}
