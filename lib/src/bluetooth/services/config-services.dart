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

    print("ConfigService: inicido ${characteristic.remoteId} | ${characteristic.uuid}");
    print("ConfigService: last value ${characteristic.lastValue}");
    print("ConfigService: Pareando service...");

    try {
      List<int> value = await characteristic.read();
      String valueStr = String.fromCharCodes(value);
      print(valueStr);
      if (value.isEmpty) return null;
      
      else if(valueStr == "{}" )
      {
        print("ConfigService: empty value default configuration.");
        var mqqtConfig = new MqqtConfig.fromString("mqtt://telemetria:kancvx8thz9FCN5jyq@broker.gpicm-ufrj.tec.br:1883");
        var mqqtV2Config = new MqqtConfig.fromString("mqtt://admin:123@146.190.171.0:1884");
        mqqtConfig.setTopic("/prefeituras/macae/estacoes/");
        var config = ConfigData(
          "",
          "",
          "",
          "",
          mqqtConfig,
          mqqtV2Config,
          "60000",
        );
        return config;
      }

      print('ConfigService: Novo valor ${value}');

      Map<String, dynamic> configMap = {};
      String configJson = String.fromCharCodes(value);
      print(configJson);
      configMap = json.decode(configJson);
      
      print("ConfigService: Lendo configuraçẽos aqui");

      String mqttConnectionString = configMap['MQTT_HOST'];
      String mqttV2ConnectionString = configMap['MQTT_HOST_V2'];
      String wifiString = configMap['WIFI'];

      List<String> wifiParts = wifiString.split(":");
      String wifiSSID = wifiParts[0];
      String password = wifiParts[1];
    
      final mqqtConfig = new MqqtConfig.fromString(mqttConnectionString);
      final mqqtV2Config = new MqqtConfig.fromString(mqttV2ConnectionString);
    
      String defaultTopic = configMap['MQTT_TOPIC'] ?? "";
      mqqtConfig.setTopic((defaultTopic));

      final config = ConfigData(
        configMap['UID'] ?? "",
        configMap['SLUG'] ?? "",
        wifiParts[0] ?? "",
        wifiParts[1] ?? "",
        mqqtConfig,
        mqqtV2Config,
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
