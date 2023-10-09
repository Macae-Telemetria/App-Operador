import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/controllers/bluetooth-controller.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-find-devices.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-off-screen.dart';

/// Displays a list of SampleItems.
class BTHomePage extends StatefulWidget {
  const BTHomePage({super.key});

  static const routeName = '/';

  @override
  State<BTHomePage> createState() => _BTHomePageState();
}

class _BTHomePageState extends State<BTHomePage> {
  final BluetoothController btController = BluetoothController();

  @override
  void initState() {
    super.initState();
    btController.setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar a Estação'),
      ),
      body: StreamBuilder<bool>(
          stream: btController.isBluetoothEnable(),
          initialData: false,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == true) {
              return FindDevicesScreen(controller: btController);
            }
            return const BluetoothOffScreen();
          }),
    );
  }
}
