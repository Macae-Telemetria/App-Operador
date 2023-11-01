import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/bluetooth-service-map.dart';
import 'package:flutter_sit_operation_application/src/domain/Metrics.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';

class HealthCheckService {
  final dataNotifier = ValueNotifier<HealthCheck?>(null);
  final metricsNotifier = ValueNotifier<Metrics?>(null);

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

        String stringEntry = String.fromCharCodes(entry);
        print("HealthCheckService: valor cru recebido: ${stringEntry}");

        if (stringEntry.startsWith('HC: ')) {
          String subString = stringEntry.substring(4);

          List<String> splitString = subString.split(',');

          String softwareVersion = splitString[0];
          bool isWifiConnected = splitString[1] == '1';
          bool isMqttConnected = splitString[2] == '1';
          int wifiDbm = int.parse(splitString[3]);
          int timestamp = int.parse(splitString[4]);
          int timeRemaining = int.parse(splitString[5]);

          print("HealthCheckService: softwareVersion: ${softwareVersion}");
          print("HealthCheckService: isWifiConnected: ${isWifiConnected}");
          print("HealthCheckService: isMqttConnected: ${isMqttConnected}");
          print("HealthCheckService: wifiDbm: ${wifiDbm}");
          print("HealthCheckService: timestamp: ${timestamp}");
          print("HealthCheckService: timeRemaining: ${timeRemaining}");

          HealthCheck data = HealthCheck(
            softwareVersion,
            timestamp,
            isWifiConnected,
            isMqttConnected,
            wifiDbm,
            timeRemaining,
          );
          print("HealthCheckService: Novo valor recebido: ${data}");
          dataNotifier.value = data;
        } else if (stringEntry.startsWith('ME')) {
          String subString = stringEntry.substring(4);
          List<String> splitString = subString.split(',');

          int timestamp = int.parse(splitString[0]);
          double? temperatura =
              splitString[1] == "null" ? null : double.parse(splitString[1]);
          double? umidadeAr =
              splitString[2] == "null" ? null : double.parse(splitString[2]);
          double velocidadeVento = double.parse(splitString[3]);
          double rajadaVento = double.parse(splitString[4]);
          int dirVento = int.parse(splitString[5]);
          double volumeChuva = double.parse(splitString[6]);
          double pressao = double.parse(splitString[7]);

          print("HealthCheckService: timestamp: ${timestamp}");
          print("HealthCheckService: temperatura: ${temperatura}");
          print("HealthCheckService: umidadeAr: ${umidadeAr}");
          print("HealthCheckService: velocidadeVento: ${velocidadeVento}");
          print("HealthCheckService: rajadaVento: ${rajadaVento}");
          print("HealthCheckService: dirVento: ${dirVento}");
          print("HealthCheckService: volumeChuva: ${volumeChuva}");
          print("HealthCheckService: pressao: ${pressao}");

          final metrics = Metrics(timestamp, temperatura, umidadeAr,
              velocidadeVento, rajadaVento, dirVento, volumeChuva, pressao);

          print("HealthCheckService: Novo valor recebido: ${metrics}");
          metricsNotifier.value = metrics;
        } else {
          print("HealthCheckService: Senhuma ação aqui");
        }
      });
    } catch (error) {
      print("HealthCheckService: Stream subscription failed.");
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



  /*           
    Map<String, dynamic> healthCheckMap = json.decode(stringEntry) ?? {};
      final data = HealthCheck(
          healthCheckMap['softwareVersion'] ?? "",
          healthCheckMap['timestamp'] ?? 0,
          healthCheckMap['isWifiConnected'] == 1 ? true : false,
          healthCheckMap['isMqttConnected'] == 1 ? true : false,
          healthCheckMap['wifiDbmLevel'],
          healthCheckMap['timeRemaining']); 
  */