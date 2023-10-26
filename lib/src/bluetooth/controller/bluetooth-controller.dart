import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothController {
  final connectedDevice = ValueNotifier<BluetoothDevice?>(null);
  final isBlueToothEnabled = ValueNotifier<bool>(false);
  final scanResults = ValueNotifier<List<ScanResult>>([]);

  scan() async {
    print('BluetoothController: Tentando escaner ...');
    scanResults.value = [];
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
  }

  stopScan() async {
    print('BluetoothController: Parando escaner ...');
    await FlutterBluePlus.stopScan();
  }

  setDevice(BluetoothDevice newDevice) {
    connectedDevice.value = newDevice;
  }

  _listenScanResult() async {
    var subscription = FlutterBluePlus.scanResults.listen(
      (results) {
        /* print('Novo rsultado: ${results}');
        for (ScanResult r in results) {
          if (seen.value.contains(r.device.remoteId) == false) {
            print(
                '${r.device.remoteId}: "${r.advertisementData.localName}" found! rssi: ${r.rssi}');
            seen.value.add(r.device.remoteId);
            scanResults.value = r;
            scanResults.value = scanResults.value;
          }
        } */
        scanResults.value = results;
      },
    );
  }

  // Initial setup
  setup() async {
    print('BluetoothController: Iniciando');

    print('BluetoothController: Check if Bluetooth is available on the device');
    if (await FlutterBluePlus.isSupported == false) {
      print("BluetoothController: BlueTooth is not supported on the device");
      SystemNavigator.pop();
      return;
    }

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    // watch bluetooth state
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print('BluetoothController: state changed ${state}');

      if (state == BluetoothAdapterState.on) {
        isBlueToothEnabled.value = true;
        // usually start scanning, connecting, etc
      } else {
        isBlueToothEnabled.value = false;
        stopScan();
      }
    });

    // listen to *any device* connection state changes
    BluetoothEvents.connectionState.listen((event) {
      print('Eventos: ${event.device} ${event.connectionState}');
      if (event.connectionState == BluetoothConnectionState.disconnected) {
        connectedDevice.value = null;
        return;
      }
      connectedDevice.value = event.device;
    });
    _listenScanResult();
  }

  Future<bool> connectDevice(context, BluetoothDevice device) async {
    try {
      print("BluetoothController: trying to connect with device");
      print("BluetoothController: ${device.remoteId}");

      // listen for disconnection
      device.connectionState.listen((BluetoothConnectionState state) async {
        print('Dispositovo estaá ${state}');
        if (state == BluetoothConnectionState.disconnected) {
          // 1. typically, start a periodic timer that tries to
          //    periodically reconnect, or just call connect() again right now
          // 2. you must always re-discover services after disconnection!
        }
      });

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

      scanResults.value = [];
      print("BluetoothController: Connected sucessfully");
      Navigator.of(context).pop();
      return true;
      // close the dialog automatically
    } catch (err) {
      print("BluetoothController: Failed to connect with device");
      print(err);
      device.disconnect();
      Navigator.of(context).pop();
      return false;
    }
  }

  Future<bool> discoverServices(BluetoothDevice device) async {
    try {
      print(
          "BluetoothController: Carregando serviços do dispositivo bluetooth");
      await device.discoverServices(timeout: 15);

      final mtuSubscription = device.mtu.listen((int mtu) {
        print("mtu $mtu");
      });

      int mtu = await device!.mtu.first;
      await device!.requestMtu(247);

      while (mtu != 247) {
        print("BluetoothController: Waiting for requested MTU $mtu");
        await Future.delayed(const Duration(seconds: 1));
        mtu = await device!.mtu.first;
      }
      // cleanup: cancel subscription when disconnected
      device.cancelWhenDisconnected(mtuSubscription);
      print("BluetoothController: FINAL MTU $mtu");
      // close the dialog automatically
      return true;
    } catch (err) {
      print("BluetoothController: Failed to discover  device services");
      print(err);
      return false;
    }
  }
}
