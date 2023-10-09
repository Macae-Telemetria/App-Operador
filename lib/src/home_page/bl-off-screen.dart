/* bt disabled */
import 'package:flutter/material.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 160.0,
              color: Colors.white54,
            ),
            Text('Bluetooth Desligado'),
          ],
        ),
      ),
    );
  }
}
