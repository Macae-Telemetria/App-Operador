import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/bluetooth-service-map.dart';
import 'package:flutter_sit_operation_application/src/domain/config-file.dart';

class ConfigService {
  final BluetoothDevice _device;

  BluetoothCharacteristic? _characteristic;

  final StreamController<ConfigData?> _controller =
      StreamController<ConfigData?>();

  ConfigService({required BluetoothDevice device}) : _device = device;

  Stream<ConfigData?> get configDataStream => _controller.stream;

  BluetoothCharacteristic? findCharacteristic() {
    if (_characteristic != null) return _characteristic;

    print("ConfigService: Encontrando caractetisticas;");

    List<BluetoothService>? availableServices = _device.servicesList;
    if (availableServices == null) return null;

    BluetoothCharacteristic? characteristic;
    try {
      BluetoothService stationService = availableServices.firstWhere((service) {
        return service.uuid == Guid(BluetoothServiceMap.stationServiceId);
      });

      print("ConfigService: Service ${stationService.uuid}");

      characteristic =
          stationService.characteristics.firstWhere((characteristic) {
        return characteristic.uuid ==
            Guid(BluetoothServiceMap.configCharacteristicId);
      });

      print("ConfigService: Characteristic ${characteristic.uuid}");
    } catch (error) {
      print("ConfigService: Serviço ou caracteristica não encontrada.");
    }

    if (characteristic == null) {
      return null;
    }

    return characteristic;
  }

  Future<ConfigData?> loadConfigData() async {
    print("ConfigService: startFetching config data.");

    BluetoothCharacteristic? characteristic = findCharacteristic();
    if (characteristic == null) {
      print("HealthCheckService: Unable to find config characteristic");
      return null;
    }

    print(
        "ConfigService: inicido ${characteristic.remoteId} | ${characteristic.uuid}");
    print("ConfigService: last value ${characteristic.lastValue}");
    print("ConfigService: Parando service...");

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

  Future<ConfigData?> writeConfigData(ConfigData configData) async {
    print("ConfigService: start to write config data.");

    BluetoothCharacteristic? characteristic = findCharacteristic();
    if (characteristic == null) {
      print("ConfigService: Unable to find config characteristic");
      return null;
    }

    try {
      // devo converter sirng to int
      print("ConfigService: Writing data");
      List<int> value = configData.toBuffer();
      await characteristic.write(value);
    } catch (err) {
      print("ConfigService: Failed to write data");
      print("ConfigService: Error -> ${err}");
    }

    return null;
  }

  Future<ConfigData?> shutDownBle() async {
    print("ConfigService: request bluettoth shutdown.");

    BluetoothCharacteristic? characteristic = findCharacteristic();
    if (characteristic == null) {
      print("ConfigService: Unable to find characteristic");
      return null;
    }

    try {
      String input = "@@BLE_SHUTDOWN";
      List<int> charCodes = [];
      for (int i = 0; i < input.length; i++) {
        int charCode = input.codeUnitAt(i);
        charCodes.add(charCode);
      }
      await characteristic.write(charCodes);
    } catch (err) {
      print("ConfigService: Failed to request buetooth shutdown");
      print("ConfigService: Error -> ${err}");
    }

    return null;
  }

  Future<ConfigData?> restartBoard() async {
    print("ConfigService: request restart board.");

    BluetoothCharacteristic? characteristic = findCharacteristic();
    if (characteristic == null) {
      print("ConfigService: Unable to find characteristic");
      return null;
    }

    try {
      String input = "@@RESTART";
      List<int> charCodes = [];
      for (int i = 0; i < input.length; i++) {
        int charCode = input.codeUnitAt(i);
        charCodes.add(charCode);
      }
      await characteristic.write(charCodes);
    } catch (err) {
      print("ConfigService: Failed to request board restart");
      print("ConfigService: Error -> ${err}");
    }

    return null;
  }

  void dispose() {
    _controller
        .close(); // Make sure to close the stream when it's no longer needed
  }
}
