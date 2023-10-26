import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/fragments/metrics-view.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/bluetooth-service-map.dart';
import 'package:flutter_sit_operation_application/src/domain/Metrics.dart';

class MetricsScreen extends StatefulWidget {
  final BluetoothDevice device;

  const MetricsScreen({super.key, required this.device});

  @override
  State<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends State<MetricsScreen> {
  BluetoothCharacteristic? findCharacteristic() {
    print("MetricsScreen: Encontrando caractetisticas;");

    List<BluetoothService>? availableServices = widget.device.servicesList;
    if (availableServices == null) return null;

    BluetoothCharacteristic? characteristic;
    try {
      BluetoothService stationService = availableServices.firstWhere((service) {
        return service.uuid == Guid(BluetoothServiceMap.stationServiceId);
      });

      print("MetricsScreen: Service ${stationService.uuid}");

      characteristic =
          stationService.characteristics.firstWhere((characteristic) {
        return characteristic.uuid ==
            Guid(BluetoothServiceMap.metricsCharacteristicId);
      });

      print("MetricsScreen: Characteristic ${characteristic.uuid}");
    } catch (error) {
      print("MetricsScreen: Serviço ou caracteristica não encontrada.");
    }

    if (characteristic == null) {
      return null;
    }

    return characteristic;
  }

  Future<Metrics?> loadMetrics() async {
    print("MetricsScreen: startFetching config data.");
    BluetoothCharacteristic? characteristic = findCharacteristic();
    if (characteristic == null) {
      print("MetricsScreen: Unable to find config characteristic");
      return null;
    }

    print(
        "MetricsScreen: inicido ${characteristic.remoteId} | ${characteristic.uuid}");
    print("MetricsScreen: Parando service...");

    try {
      List<int> value = await characteristic.read();

      if (value.isEmpty) return null;

      Map<String, dynamic> configMap = {};

      if (value.isNotEmpty) {
        String configJson = String.fromCharCodes(value);
        print(configJson);
        configMap = json.decode(configJson);
      }

      final metrics = Metrics(
        configMap['timestamp'],
        configMap['temperatura'],
        configMap['umidade_ar'],
        configMap['velocidade_vento'],
        configMap['rajada_vento'],
        configMap['dir_vento'],
        configMap['volume_chuva'],
        configMap['pressao'],
      );
      print("MetricsScreen: ${metrics}");
      return metrics;
    } catch (err) {
      print("MetricsScreen: Error");
      print("MetricsScreen: ${err}");
    }

    return null;
  }

  @override
  void initState() {
    print("MetricsScreen: Iniciado");
    super.initState();
  }

  @override
  void dispose() {
    print("MetricsScreen: vamos fazer um dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadMetrics(),
        initialData: null,
        builder: (BuildContext context, snapshot) {
          print("ConfigurationScreen: snapshot");
          print(snapshot.data);
          if (snapshot.data == null) {
            return const Text("Carregando...");
          }
          return MetricsView(snapshot.data!);
        });
  }
}
