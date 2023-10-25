import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/controller/bluetooth-controller.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/off-screen.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/on-screen.dart';

/// Displays a list of SampleItems.
class BTHomeScreen extends StatefulWidget {
  BTHomeScreen({super.key});

  static const routeName = '/';

  @override
  State<BTHomeScreen> createState() => _BTHomeScreenState();
}

class _BTHomeScreenState extends State<BTHomeScreen> {
  final BluetoothController controller = BluetoothController();

  @override
  void initState() {
    super.initState();
    controller.setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar a Estação'),
      ),
      body: Center(
        child: ValueListenableBuilder<bool>(
            valueListenable: controller.isBlueToothEnabled,
            builder: (context, result, child) {
              if (result == false) return const BluetoothOffScreen();
              return BluetoothOnScreen(controller: controller);
            }),
      ),
    );
  }
}
