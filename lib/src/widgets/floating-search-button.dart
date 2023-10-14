import 'package:flutter/material.dart';

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
    return FloatingActionButton.large(
      onPressed: () => isRunning ? onStop() : onStart(),
      backgroundColor: isRunning ? Colors.red : Colors.blue,
      child: isRunning ? const Icon(Icons.stop) : const Icon(Icons.search),
    );
  }
}
