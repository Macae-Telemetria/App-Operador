/* bt disabled */
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/controller/bluetooth-controller.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/bluetooth-device-screen.dart';
import 'package:flutter_sit_operation_application/src/widgets/device-tile.dart';

class BluetoothOnScreen extends StatefulWidget {
  final BluetoothController controller;

  const BluetoothOnScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  State<BluetoothOnScreen> createState() => _BluetoothOnScreenState();
}

class _BluetoothOnScreenState extends State<BluetoothOnScreen> {
  List<Widget> _renderScanResult(context, List<ScanResult> scanResult) {
    if (scanResult.isEmpty) return [];

    onPress(BluetoothDevice device) async {
      try {
        await widget.controller.connectDevice(context, device);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Conectado com sucesso!"),
        ));
      } catch (error) {
        print('Não foi possivel');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Não foi possivel estabelecer Conexão."),
        ));
      }
    }

    var devices = (scanResult).map((s) => s.device);
    return devices
        .map((device) => DeviceTile(
            name: device.platformName,
            subtitle: device.remoteId.toString(),
            isconnected: false,
            onTap: () => onPress(device)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: ValueListenableBuilder<BluetoothDevice?>(
          valueListenable: widget.controller.connectedDevice,
          builder: (context, device, child) {
            if (device == null) {
              return ValueListenableBuilder<List<ScanResult>>(
                  valueListenable: widget.controller.scanResults,
                  builder: (context, result, child) {
                    return Column(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _renderScanResult(context, result)),
                        StreamBuilder<bool>(
                            stream: FlutterBluePlus.isScanning,
                            initialData: false,
                            builder: (c, snapshot) {
                              bool isScanning = snapshot.data ?? false;
                              return Column(
                                children: [
                                  Text("${isScanning ? "Procurando" : "..."}"),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (isScanning) {
                                          widget.controller.stopScan();
                                          return;
                                        }
                                        widget.controller.scan();
                                      },
                                      child: Text(
                                          "${isScanning ? "Parar" : "Escanerar"}")),
                                ],
                              );
                            }),
                      ],
                    );
                  });
            }
            return FutureBuilder<bool>(
                future: widget.controller.discoverServices(device),
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show a loading indicator while discovering services
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return DeviceScreen(device: device);
                  } else {
                    return Text('Não é uma estação valida!');
                  }
                });
          }),
    );
  }
}
