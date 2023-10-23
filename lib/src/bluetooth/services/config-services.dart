import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/health-check-services.dart';
import 'package:flutter_sit_operation_application/src/domain/config-file.dart';

class ConfigService {
  late BluetoothCharacteristic characteristic;

  final StreamController<ConfigData?> _controller =
      StreamController<ConfigData?>();

  void setCharacteristic(c) {
    characteristic = c;
  }

  Stream<ConfigData?> get configDataStream => _controller.stream;

  Future<ConfigData?> loadConfigData() async {
    print("ConfigService: inicido ${characteristic.remoteId}");
    print("ConfigService: inicido ${characteristic.uuid}");
    print("ConfigService: last value ${characteristic.lastValue}");

    print("ConfigService: Parando healcheck service...");

    try {
      List<int> value = await characteristic.read();

      if (value.isEmpty) return null;

      print('ConfigService: Novo valor ${value}');

      Map<String, dynamic> configMap = {};

      if (value.isNotEmpty) {
        String configJson = String.fromCharCodes(value);
        print(configJson);
        configMap = json.decode(configJson);
      }

      final config = ConfigData(
        configMap['STATION_UID'] ?? "",
        configMap['STATION_NAME'] ?? "",
        configMap['WIFI_SSID'] ?? "",
        configMap['WIFI_PASSWORD'] ?? "",
        configMap['MQTT_SERVER'] ?? "",
        configMap['MQTT_USERNAME'] ?? "",
        configMap['MQTT_PASSWORD'] ?? "",
        configMap['MQTT_TOPIC'] ?? "",
        configMap['MQTT_PORT'].toString(),
        configMap['INTERVAL'].toString(),
      );
      print("ConfigService: ${config}");
      return config;
    } catch (err) {
      print("ConfigService: Error");
      print("ConfigService: ${err}");
    }

    return null;
  }

  Stream<ConfigData?> _loadConfigData(
      BluetoothCharacteristic configCharacteristic) {
    final controller = StreamController<ConfigData?>();

    try {
      var sub = configCharacteristic.onValueReceived.listen((List<int> value) {
        print(value);
        if (value.isEmpty) return;

        print('ConfigService: Novo valor ${value}');

        Map<String, dynamic> configMap = {};

        if (value.isNotEmpty) {
          String configJson = String.fromCharCodes(value);
          print(configJson);
          configMap = json.decode(configJson);
        }

        final config = ConfigData(
          configMap['STATION_UID'] ?? "",
          configMap['STATION_NAME'] ?? "",
          configMap['WIFI_SSID'] ?? "",
          configMap['WIFI_PASSWORD'] ?? "",
          configMap['MQTT_SERVER'] ?? "",
          configMap['MQTT_USERNAME'] ?? "",
          configMap['MQTT_PASSWORD'] ?? "",
          configMap['MQTT_TOPIC'] ?? "",
          configMap['MQTT_PORT'].toString(),
          configMap['INTERVAL'].toString(),
        );

        controller.add(config);
      });
    } catch (error) {
      print("StationDeviceScreen: Serviço ou caracteristica não encontrada.");
      controller.addError(error);
      controller.close();
    }

    return controller.stream;
  }

  void dispose() {
    _controller
        .close(); // Make sure to close the stream when it's no longer needed
  }
}
