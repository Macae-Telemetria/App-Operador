import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/bluetooth-service-map.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';

class HealthCheckService {
  final BluetoothDevice _device;

  BluetoothCharacteristic? _characteristic;

  final StreamController<HealthCheck?> _controller =
      StreamController<HealthCheck?>();

  HealthCheckService({required BluetoothDevice device}) : _device = device;

  Stream<HealthCheck?> get healthCheckStream => _controller.stream;

  BluetoothCharacteristic? findCharacteristic() {
    if (_characteristic != null) return _characteristic;

    print("HealthCheckService: Encontrando caractetisticas;");

    List<BluetoothService>? availableServices = _device.servicesList;
    if (availableServices == null) return null;

    BluetoothCharacteristic? characteristic;
    try {
      BluetoothService stationService = availableServices.firstWhere((service) {
        return service.uuid == Guid(BluetoothServiceMap.stationServiceId);
      });

      print("HealthCheckService: Service ${stationService.uuid}");

      characteristic =
          stationService.characteristics.firstWhere((characteristic) {
        return characteristic.uuid ==
            Guid(BluetoothServiceMap.healthCheckCharacteristicId);
      });

      print("HealthCheckService: Characteristic ${characteristic.uuid}");
    } catch (error) {
      print("HealthCheckService: Serviço ou caracteristica não encontrada.");
    }

    if (characteristic == null) {
      return null;
    }

    return characteristic;
  }

  Future<bool> startFetching() async {
    print("HealthCheckService: startFetching Inciando notifcation");
    BluetoothCharacteristic? characteristic = findCharacteristic();
    if (characteristic == null) {
      print("HealthCheckService: Unable to find healthcheck characteristic");
      return false;
    }

    loadData(_device, characteristic).listen((configData) {
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
            healthCheckMap['wifiDbmLevel'],
            healthCheckMap['timeRemaining']);

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
    // await characteristic.setNotifyValue(false, timeout: 8);
  }

  Future<void> stopFetching() async {
    print("Parando caractetistica");
    _controller.close();
  }
}
