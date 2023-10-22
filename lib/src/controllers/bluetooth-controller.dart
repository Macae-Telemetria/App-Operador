import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sit_operation_application/src/controllers/station-service.dart';

class BluetoothController extends ChangeNotifier {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];
  // Initial setup
  setup() async {
    print('BluetoothController: Iniciando');
    print('BluetoothController: Check if Bluetooth is available on the device');
    bool isAvailable = await flutterBlue.isAvailable;
    if (!isAvailable) {
      print("BluetoothController: BlueTooth is not supported on the device");
      SystemNavigator.pop();
      return;
    }

    print("BluetoothController: Ok");
  }

  // Check if bt is anabled
  Stream<bool> isBluetoothEnable() async* {
    await for (var state in flutterBlue.state) {
      yield state == BluetoothState.on;
    }
  }

  // start to scan
  Future<void> startScanning() async {
    print("Vamos scanear aqui");
    bool isOn = await flutterBlue.isOn;
    if (isOn) {
      print("Esta ativo");
      flutterBlue.startScan(timeout: Duration(seconds: 4));
    } else {
      print("Não esta ativo");
    }
  }

  // stop scanning
  Future<void> stopScanning() async {
    await flutterBlue.stopScan();
  }

  // check is scanning
  Stream<bool> isScanning() {
    return flutterBlue.isScanning;
  }

  // check is scanning
  Stream<List<ScanResult>> getScanResults() {
    return flutterBlue.scanResults;
    /*    return flutterBlue.scanResults.map((List<ScanResult> scanResults) {
      return scanResults.map((ScanResult result) {
        return result;
      }).toList();
    }); */
  }

  // get connected devices
  Future<List<BluetoothDevice>> getConnectedDevices() {
    print("BluetoothController: tryin to get connected devices");
    return flutterBlue.connectedDevices;
  }

  Future<void> connectDevice(context, BluetoothDevice device) async {
    try {
      print("BluetoothController: trying to connect with device");
      print("BluetoothController: ${device.id}");

      showDialog(
          // The user CANNOT close this dialog  by pressing outsite it
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return const Dialog(
              // The background color
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The loading indicator
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    // Some text
                    Text('Conectando...')
                  ],
                ),
              ),
            );
          });

      await device.connect(timeout: Duration(seconds: 8), autoConnect: true);
      print("BluetoothController: Connected sucessfully");
      Navigator.of(context).pop();
      return;
      // close the dialog automatically
    } catch (err) {
      print("BluetoothController: Failed to connect with device");
      print(err);
      Navigator.of(context).pop();
    }
  }

  Future<void> disconnectDevice(BluetoothDevice device) async {
    print("BluetoothController: tryin to disconnect with device");
    print("BluetoothController: ${device.id}");
    device.disconnect();
  }

  void readValue(serviceId, characteristicId, payload) {
    print("BluetoothController: tryin  read new value");
    if (serviceId == Guid(StationService.stationServiceId)) {
      print("Novo valor Recebido: ${characteristicId}");
      StationService().loadConfig(String.fromCharCodes(payload));
    }
  }
}




/*   

    /*
      final Map ){<Guid, List<int>> readValues = new Map<Guid, List<int>>();
    */

 _addDeviceTolist(final BluetoothDevice device) {
   if (!widget.devicesList.contains(device)) {
     setState(() {
       widget.devicesList.add(device);
     });
   } */

    /*    return await (flutterBlue.connectedDevices)
        .map((List<BluetoothDevice> devices) {
      return devices.map((BluetoothDevice result) {
        return result;
      }).toList();
    }); */

      /*   
  void getConnectedDevicesAsync() {
  print("tryin to get connected devices AYSNC");

    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        print('>>>>>> ${device.name} found!');
      }
    });

    print("lISTNER DONW");
  }
 */