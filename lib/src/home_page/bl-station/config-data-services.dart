import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sit_operation_application/src/controllers/station-service.dart';
import 'package:flutter_sit_operation_application/src/domain/config-file.dart';

class ConfigDataService {
  final StreamController<ConfigData?> _controller =
      StreamController<ConfigData?>();

  Stream<ConfigData?> get configDataStream => _controller.stream;

  void loadConfigData(List<BluetoothService> services) {
    _loadConfigData(services).listen((configData) {
      _controller.sink.add(configData);
      _controller.close(); // Close the stream after adding the data once
    });
  }

  Stream<ConfigData?> _loadConfigData(List<BluetoothService> services) {
    final controller = StreamController<ConfigData?>();
    BluetoothCharacteristic? configCharacteristic;

    void _handleValue(List<int> value) {
      print(value);
      if (value.isEmpty) return;

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
    }

    try {
      BluetoothService stationService = services.firstWhere((service) {
        return service.uuid == Guid(StationService.stationServiceId);
      });

      configCharacteristic =
          stationService.characteristics.firstWhere((characteristic) {
        return characteristic.uuid ==
            Guid(StationService.configCharacteristicId);
      });

      print("StationDeviceScreen: Characteristic ${configCharacteristic.uuid}");
      print('StationDeviceScreen: Lendo Configuração');

      var sub = configCharacteristic.value.listen(_handleValue);

      configCharacteristic.read().then((_) {
        // sub.cancel();
        // controller.close();
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
