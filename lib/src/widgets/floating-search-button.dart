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
        width: 142,
        height: 142,
        child: FloatingActionButton.large(
          onPressed: () => isRunning ? onStop() : onStart(),
          backgroundColor: isRunning ? Colors.red : primaryColor,
          child: isRunning
              ? const Icon(Icons.stop, color: Colors.white,)
              : const Icon(Icons.search, color: Colors.white, size: 48),
        ));
  }
}
