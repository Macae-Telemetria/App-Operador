import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/bluetooth-service-map.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';

class HealthCheckService {
  final dataNotifier = ValueNotifier<HealthCheck?>(null);

  final BluetoothDevice _device;

  BluetoothCharacteristic? _characteristic;

  late StreamSubscription<List<int>> _streamSubscription;

  HealthCheckService({required BluetoothDevice device}) : _device = device;

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

    try {
      _streamSubscription = characteristic.lastValueStream.listen((value) {});

      // cleanup: cancel subscription when disconnected
      _device.cancelWhenDisconnected(_streamSubscription);

      _streamSubscription.onData((entry) {
        if (entry.isEmpty) {
          return;
        }

        String jsonMap = String.fromCharCodes(entry);
        Map<String, dynamic> healthCheckMap = json.decode(jsonMap) ?? {};

        final data = HealthCheck(
            healthCheckMap['softwareVersion'] ?? "",
            healthCheckMap['timestamp'] ?? 0,
            healthCheckMap['isWifiConnected'] == 1 ? true : false,
            healthCheckMap['isMqttConnected'] == 1 ? true : false,
            healthCheckMap['wifiDbmLevel'],
            healthCheckMap['timeRemaining']);

        print(" Novo valor recebido: ${data}");
        dataNotifier.value = data;
      });
    } catch (error) {
      print("Strem subscription failed.");
      _streamSubscription.cancel();
    }

    await characteristic.setNotifyValue(true, timeout: 8);
    print("HealthCheckService: startFetching notifications prontas;");
    return true;
  }

  Future<void> stopFetching() async {
    print("Parando caractetistica");
    try {
      print("HealthCheckService: Tentando cancelar notificações");
      await _streamSubscription.cancel();
      /* 
        await _characteristic?.setNotifyValue(false); 
        dataNotifier.value = null;
      */
      print("HealthCheckService: Parado com sucesso;");
    } catch (error) {
      print("HealthCheckService: Falou em para notificações");
    }
  }
}
