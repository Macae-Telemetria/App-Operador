import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/widgets/loading-dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController {
  final connectedDevice = ValueNotifier<BluetoothDevice?>(null);
  final isBlueToothEnabled = ValueNotifier<bool>(false);
  final scanResults = ValueNotifier<List<ScanResult>>([]);

  scan() async {
    print('BluetoothController: Tentando escaner ...');
    try {
      if (await Permission.bluetoothScan.request().isGranted) {
        if (await Permission.bluetoothConnect.request().isGranted) {
          print('BluetoothController: tempos permissção ...');

          scanResults.value = [];
          await FlutterBluePlus.startScan(
              timeout: Duration(seconds: 5), androidUsesFineLocation: true);
        }
      }
    } catch (error) {
      print('BluetoothController: Captured execption: ${error}');
    }
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
        print('BluetoothController: Novos resultados: ${results}');

        if (results.isNotEmpty) {
          String targetPrefix = "SIT-BOARD-";
          List<ScanResult> filteredResults = results
              .where((result) =>
                  result.device.platformName != null &&
                  result.device.platformName.startsWith(targetPrefix))
              .toList();
          scanResults.value = filteredResults;
        }
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
        print('Dispositivo está ${state}');
        if (state == BluetoothConnectionState.disconnected) {
          // 1. typically, start a periodic timer that tries to
          //    periodically reconnect, or just call connect() again right now
          // 2. you must always re-discover services after disconnection!
        }
      });

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return const LoadingDialog(
              title: "Conectando...",
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
      await device!.requestMtu(420);

      while (mtu != 420) {
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


  /* if (connectedDevice == null) {
          for (ScanResult r in results) {
            print(
                '${r.device.remoteId}: "${r.advertisementData.localName}" found! rssi: ${r.rssi}');
            connectDevice(r.device);
            break;
          }
        } */