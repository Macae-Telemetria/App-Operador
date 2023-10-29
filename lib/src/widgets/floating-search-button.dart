import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/shared/styles.dart';

class FloatingSearchButton extends StatelessWidget {
  final bool isRunning;
  final void Function() onStart;
  final void Function() onStop;

  const FloatingSearchButton({
    super.key,
    required this.isRunning,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 140,
        height: 140,
        child: FloatingActionButton.large(
          onPressed: () => isRunning ? onStop() : onStart(),
          backgroundColor: isRunning ? Colors.red : secondaryColor,
          child: isRunning
              ? const Icon(Icons.stop)
              : const Icon(Icons.search, size: 48),
        ));
  }
}
