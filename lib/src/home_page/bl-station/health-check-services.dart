import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sit_operation_application/src/controllers/station-service.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';

class YourHealthCheckService {
  // Timer? _timer;
  final StreamController<HealthCheck?> _controller =
      StreamController<HealthCheck?>();

  Stream<HealthCheck?> get healthCheckStream => _controller.stream;

  Future<void> startFetching(
      BluetoothCharacteristic hCheckcharacteristic) async {
    await hCheckcharacteristic.setNotifyValue(true);
    _loadHealthCheckData(hCheckcharacteristic).listen((data) {
      _controller.sink.add(data);
    });
  }

  Stream<HealthCheck?> _loadHealthCheckData(
      BluetoothCharacteristic characteristic) {
    final controller = StreamController<HealthCheck?>();

    /*  try {
      characteristic.value.listen((List<int> value) {
        print("Novo valor lindo --> ");

        print(value);

        if (value.isEmpty) {
          controller.add(null);
          return;
        }
        /* String jsonMap = String.fromCharCodes(value);
      print("String Parsed --> ");
      print(jsonMap); */

        /* Map<String, dynamic> healthCheckMap = json.decode(jsonMap) ?? {};

      print("map result aqui --> ");

      print(healthCheckMap);

      final data = HealthCheck(
          healthCheckMap['softwareVersion'] ?? 0,
          healthCheckMap['timestamp'] ?? 0,
          healthCheckMap['isWifiConnected'] == 1 ? true : false,
          healthCheckMap['isMqttConnected'] == 1 ? true : false,
          healthCheckMap['wifiDbmLevel']);

      print("final");
      print(data.toString());
      controller.add(data); */
        controller.add(null);
        return;
      });

      // var sub = hCheckcharacteristic.value.listen(_handleValue);

      // await hCheckcharacteristic.setNotifyValue(true);

      /* hCheckcharacteristic.read().then((_) {
        sub.cancel();
        controller.close();
      }).catchError((error) {
        print('!!!!Expeciton here');
      });

      hCheckcharacteristic.value.listen((value) {
          widget.readValues[characteristic.uuid] = value;
        });
       */
    } catch (error) {
      print("Deu ruim aqui");
      controller.addError(error);
      controller.close();
    } */

    return controller.stream;
  }

  void stopFetching() {
    _controller.close();
  }
}
