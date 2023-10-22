import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sit_operation_application/src/controllers/bluetooth-controller.dart';
import 'package:flutter_sit_operation_application/src/widgets/device-tile.dart';
import 'package:flutter_sit_operation_application/src/widgets/floating-search-button.dart';

import 'bl-station/bl-station-view.dart';

class FindDevicesScreen extends StatelessWidget {
  final BluetoothController controller = BluetoothController();

  FindDevicesScreen({Key? key}) // required this.controller})
      : super(key: key);

  void moveToDevice(context, device) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => StationDeviceScreen(device: device)));
    /* onReadValues: (serviceId, characteristicId, payload) {
              controller.readValue(serviceId, characteristicId, payload);
            })) */
  }

  List<Widget> _renderScanResult(context, List<ScanResult> scanResult) {
    if (scanResult.isEmpty) return [];

    onPress(BluetoothDevice device) async {
      try {
        await controller.connectDevice(context, device);
        print("Conectado com sucesso");
        moveToDevice(context, device);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Conectado com sucesso!"),
        ));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Não foi possivel estabelecer Conexão."),
        ));
      }
    }

    var devices = (scanResult).map((s) => s.device);
    return devices
        .map((device) => DeviceTile(
            name: device.name,
            subtitle: device.id.toString(),
            isconnected: false,
            onTap: () => onPress(device)))
        .toList();
  }

  List<Widget> _renderConnectedDevices(context, List<BluetoothDevice> devices) {
    if (devices.isEmpty) return [];

    onPress(BluetoothDevice device) async {
      try {
        print('Iniciando dispositivo');
        moveToDevice(context, device);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Não foi encontrar Dispositivo."),
        ));
      }
    }

    return devices
        .map((device) => DeviceTile(
            name: device.name,
            subtitle: device.id.toString(),
            isconnected: true,
            onTap: () => onPress(device)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StreamBuilder<List<BluetoothDevice>>(
              initialData: [],
              stream: Stream.periodic(const Duration(seconds: 1))
                  .asyncMap((_) => controller.getConnectedDevices()),
              builder: (c, snapshot) {
                List<BluetoothDevice> devices = snapshot.data!;

                if (devices.isEmpty) {
                  return Column(children: [
                    StreamBuilder<List<ScanResult>>(
                      stream:
                          controller.getScanResults(), // .instance.scanResults,
                      initialData: [],
                      builder: (c, snapshot) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                _renderScanResult(context, snapshot.data!));
                      },
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: StreamBuilder<bool>(
                        stream: controller.isScanning(),
                        initialData: false,
                        builder: (c, snapshot) {
                          return FloatingSearchButton(
                              isRunning: snapshot.data!,
                              onStart: controller.startScanning,
                              onStop: controller.stopScanning);
                        },
                      ),
                    )
                  ]);
                }
                return Column(
                    children: _renderConnectedDevices(context, devices));
              }),
        ],
      ),
    ));
  }
}
