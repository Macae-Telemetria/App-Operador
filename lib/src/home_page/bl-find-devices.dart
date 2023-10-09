import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sit_operation_application/src/controllers/bluetooth-controller.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-station-device.dart';

class FindDevicesScreen extends StatelessWidget {
  final BluetoothController controller;

  const FindDevicesScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text("Dispositivos Conectados: ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(const Duration(seconds: 2))
                    .asyncMap((_) => controller.getConnectedDevices()),
                initialData: [],
                builder: (c, snapshot) {
                  print("New snapshot: ${snapshot}");
                  return Column(
                    children: snapshot.data!
                        .map((d) => ListTile(
                              title: Text(d.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              subtitle: Text(d.id.toString()),
                              leading: IconButton(
                                icon: const Icon(Icons.bluetooth_connected),
                                onPressed: () {},
                              ),
                              trailing: StreamBuilder<BluetoothDeviceState>(
                                stream: d.state,
                                initialData: BluetoothDeviceState.disconnected,
                                builder: (c, snapshot) {
                                  print("Data snapshot: ${snapshot.data}");
                                  if (snapshot.data ==
                                      BluetoothDeviceState.connected) {
                                    return IconButton(
                                      icon: const Icon(Icons.edit_note),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StationDeviceScreen(
                                                        device: d,
                                                        onReadValues: (serviceId,
                                                            characteristicId,
                                                            payload) {
                                                          controller.readValue(
                                                              serviceId,
                                                              characteristicId,
                                                              payload);
                                                        })));
                                      },
                                    );
                                  }
                                  return const Text("Desconectado");
                                },
                              ),
                            ))
                        .toList(),
                  );
                }),
            StreamBuilder<List<ScanResult>>(
              stream: controller.getScanResults(), // .instance.scanResults,
              initialData: [],
              builder: (c, snapshot) {
                var scanResult = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    scanResult.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 1,
                                width: double.infinity,
                                color: Colors.grey.shade300,
                              ),
                              Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: const Text(
                                      "Novos Dispositivos Encontrados: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16))),
                            ],
                          )
                        : Text(""),
                    Column(
                      children: (snapshot.data)!
                          .map(
                            (r) => ListTile(
                              leading: IconButton(
                                icon: const Icon(
                                    Icons.bluetooth_disabled_outlined),
                                onPressed: () {},
                              ),
                              trailing: ElevatedButton(
                                child: const Text('Conectar'),
                                onPressed: () {
                                  controller.connectDevice(r.device);
                                },
                              ),
                              title: Text("${r.device.name}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              subtitle: Text(r.device.id.toString()),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: controller.isScanning(),
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => controller.stopScanning(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => controller.startScanning());
          }
        },
      ),
    );
  }
}
