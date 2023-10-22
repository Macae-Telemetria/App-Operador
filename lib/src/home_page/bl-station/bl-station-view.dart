import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sit_operation_application/src/controllers/station-service.dart';
import 'package:flutter_sit_operation_application/src/domain/config-file.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-station/config-data-services.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-station/healthcheck.view.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-station/health-check-services.dart';

class StationDeviceScreen extends StatefulWidget {
  StationDeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  State<StationDeviceScreen> createState() => _StationDeviceScreenState();
}

class _StationDeviceScreenState extends State<StationDeviceScreen> {
  final YourHealthCheckService healthCheckService = YourHealthCheckService();

  final ConfigDataService configDataService = ConfigDataService();

  @override
  void dispose() {
    healthCheckService.stopFetching();
    super.dispose();
  }

  Future<void> loadServices() async {
    print('StationDeviceScreen: Trying to load services');

    List<BluetoothService> services = await widget.device.discoverServices();
    if (services.isEmpty) {
      print("StationDeviceScreen: Não é uma estação valida! #1");
      return;
    }

    BluetoothCharacteristic? hCheckcharacteristic;
    try {
      BluetoothService stationService = services.firstWhere((service) {
        return service.uuid == Guid(StationService.stationServiceId);
      });
      print("StationDeviceScreen: Service ${stationService.uuid}");
      hCheckcharacteristic =
          stationService.characteristics.firstWhere((characteristic) {
        return characteristic.uuid ==
            Guid(StationService.healthCheckCharacteristicId);
      });
      print("StationDeviceScreen: Characteristic ${hCheckcharacteristic.uuid}");
    } catch (error) {
      print("StationDeviceScreen: Serviço ou caracteristica não encontrada.");
    }

/*     final mtu = await widget.device.mtu.first;
    print("prev mtu: ${mtu}");
    await widget.device.requestMtu(512);

    final newMtu = await widget.device.mtu.first;
    print("new mtu: ${newMtu}"); */

    if (hCheckcharacteristic == null) return;
    await healthCheckService.startFetching(hCheckcharacteristic);
    // configDataService.loadConfigData(services);
    return;
  }

  /* Stream<ConfigData?> _loadConfigData(List<BluetoothService> services) {
    final controller = StreamController<ConfigData?>();
    BluetoothCharacteristic? configCharacteristic;

    void _handleValue(List<int> value) {
      print(value);
      if (value.isEmpty) return;

      Map<String, dynamic> configMap = {};

      if (value.isNotEmpty) {
        String configJson = String.fromCharCodes(value);
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
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.device.name}"),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => widget.device.disconnect();
                  text = 'Desconectar';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => widget.device.connect();
                  text = 'Conectar';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return ElevatedButton(onPressed: onPressed, child: Text(text));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
                stream: widget.device.state,
                initialData: BluetoothDeviceState.connecting,
                builder: (c, snapshot) {
                  var state = snapshot.data!;

                  return Column(
                    children: [
                      ListTile(
                        leading: (state == BluetoothDeviceState.connected)
                            ? const Icon(Icons.bluetooth_connected)
                            : const Icon(Icons.bluetooth_disabled),
                        title: Text('${state.toString().split('.')[1]}.'),
                        subtitle: Text('${widget.device.id}'),
                        trailing: StreamBuilder<bool>(
                          stream: widget.device.isDiscoveringServices,
                          initialData: false,
                          builder: (c, snapshot) => IndexedStack(
                            index: snapshot.data! ? 1 : 0,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    if (state ==
                                        BluetoothDeviceState.connected) {
                                      loadServices();
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                      if (state == BluetoothDeviceState.connecting)
                        const Text("conectado...")
                      else if (state == BluetoothDeviceState.connected)
                        Column(
                          children: [
                            StreamBuilder<HealthCheck?>(
                                stream: healthCheckService
                                    .healthCheckStream, // _loadHealthCheckData(services),
                                initialData: null,
                                builder: (BuildContext context, snapshot) {
                                  print(snapshot);
                                  if (snapshot.data == null)
                                    return const Text("Carregando...");
                                  return HealthChecklView(snapshot.data!);
                                }),
                          ],
                        )
                      else
                        const Text("Desconectado."),

                      // Config data
                      /* StreamBuilder<ConfigData?>(
                          stream: configDataService.configDataStream,
                          initialData: null,
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.data == null) {
                              return const Text("Carregando...");
                            }
                            return ConfigView(
                                config: (snapshot.data!),
                                onSubmit: (config) async {
                                  return true;
                                });
                          }), */
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
