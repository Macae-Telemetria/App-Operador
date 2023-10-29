import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/controller/bluetooth-controller.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/off-screen.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/on-screen.dart';

/// Displays a list of SampleItems.
class BTHomeScreen extends StatefulWidget {
  final BluetoothController controller;

  const BTHomeScreen({super.key, required this.controller});

  static const routeName = '/bt';

  @override
  State<BTHomeScreen> createState() => _BTHomeScreenState();
}

class _BTHomeScreenState extends State<BTHomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder<bool>(
            valueListenable: widget.controller.isBlueToothEnabled,
            builder: (context, result, child) {
              if (result == false) return const BluetoothOffScreen();
              return BluetoothOnScreen(controller: widget.controller);
            }),
      ),
    );
  }
}
