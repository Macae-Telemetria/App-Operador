import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';

class HealthCheckService {
  late BluetoothCharacteristic characteristic;
  final StreamController<HealthCheck?> _controller =
      StreamController<HealthCheck?>();

  Stream<HealthCheck?> get healthCheckStream => _controller.stream;

  void setCharacteristic(c) {
    characteristic = c;
  }

  Future<bool> startFetching(BluetoothDevice device) async {
    print("HealthCheckService:startFetching Inciando notifcation");

    if (characteristic == null) return false;

    loadData(device, characteristic).listen((configData) {
      _controller.sink.add(configData);
      // _controller.close(); // Close the stream after adding the data once
    });

    await characteristic.setNotifyValue(true, timeout: 8);
    print("HealthCheckService:startFetching notifications prontas;");
    return true;
  }

  Stream<HealthCheck?> loadData(
      BluetoothDevice device, BluetoothCharacteristic characteristic) {
    final controller = StreamController<HealthCheck?>();

    try {
      final chrSubscription = characteristic.lastValueStream.listen((value) {
        print("HealthCheckService: Novo valor lindo --> ${value} ");

        if (value.isEmpty) {
          controller.add(null);
          return;
        }

        String jsonMap = String.fromCharCodes(value);
        print("HealthCheckService: String Parsed --> ${jsonMap}");

        Map<String, dynamic> healthCheckMap = json.decode(jsonMap) ?? {};

        print("map result aqui --> ");

        print(healthCheckMap);

        final data = HealthCheck(
            healthCheckMap['softwareVersion'] ?? "",
            healthCheckMap['timestamp'] ?? 0,
            healthCheckMap['isWifiConnected'] == 1 ? true : false,
            healthCheckMap['isMqttConnected'] == 1 ? true : false,
            healthCheckMap['wifiDbmLevel']);

        print("HealthCheckService: final ${data.toString()}");
        controller.add(data);

        return;
      });

      // cleanup: cancel subscription when disconnected
      device.cancelWhenDisconnected(chrSubscription);
    } catch (error) {
      print("Deu ruim aqui");
      controller.addError(error);
      controller.close();
    }
    return controller.stream;
  }

  Future<void> stopNotifying() async {
    await characteristic.setNotifyValue(false, timeout: 8);
  }

  Future<void> stopFetching() async {
    print("Parando caractetistica");
    _controller.close();
  }
}
