import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/reports-screen.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/bluetooth-service-map.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/config-services.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/health-check-services.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-station/config-view.dart';

class DeviceScreen extends StatefulWidget {
  DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final HealthCheckService healthCheckService = HealthCheckService();
  final ConfigService configService = ConfigService();

  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() {
    List<BluetoothService>? availableServices = widget.device.servicesList;
    if (availableServices == null) return;

    BluetoothCharacteristic? configcharacteristic;
    BluetoothCharacteristic? hCheckcharacteristic;

    try {
      BluetoothService stationService = availableServices.firstWhere((service) {
        return service.uuid == Guid(BluetoothServiceMap.stationServiceId);
      });

      print("DeviceScreen: Service ${stationService.uuid}");

      configcharacteristic =
          stationService.characteristics.firstWhere((characteristic) {
        return characteristic.uuid.toString().toLowerCase() ==
            BluetoothServiceMap.configCharacteristicId;
      });

      hCheckcharacteristic =
          stationService.characteristics.firstWhere((characteristic) {
        return characteristic.uuid ==
            Guid(BluetoothServiceMap.healthCheckCharacteristicId);
      });

      print("DeviceScreen: Characteristic ${configcharacteristic.uuid}");
    } catch (error) {
      print("DeviceScreen: Serviço ou caracteristica não encontrada.");
    }

    if (configcharacteristic == null || hCheckcharacteristic == null) {
      return;
    }

    healthCheckService.setCharacteristic(hCheckcharacteristic);
    configService.setCharacteristic(configcharacteristic);
  }

  Widget _buildConfigService() {
    if (configService == null) return const Text("Não disponivel");
    return FutureBuilder(
        future: configService!.loadConfigData(),
        initialData: null,
        builder: (BuildContext context, snapshot) {
          print("DeviceScreen: snapshot");
          print("DeviceScreen: ${snapshot.data}");
          if (snapshot.data == null) {
            return const Text("Aguardando configuração...");
          }
          return ConfigView(
              config: (snapshot.data!),
              onSubmit: (config) async {
                return true;
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<BluetoothConnectionState>(
                stream: widget.device.connectionState,
                initialData: BluetoothConnectionState.connected,
                builder: (c, snapshot) {
                  var state = snapshot.data!;
                  return Column(
                    children: [
                      ListTile(
                        leading: (state == BluetoothConnectionState.connected)
                            ? const Icon(Icons.bluetooth_connected)
                            : const Icon(Icons.bluetooth_disabled),
                        title: Text('${state.toString().split('.')[1]}.'),
                        subtitle: Text('${widget.device.remoteId}'),
                      ),
                      Text('contectado: ${state}'),
                      IndexedStack(
                        index: _currentIndex,
                        children: [
                          ReportsScreen(
                              device: widget.device,
                              healthCheckService: healthCheckService),

                          // _buildConfigService()
                        ],
                      )
                    ],
                  );
                }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_audio_rounded),
            label: 'HealthCheck',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_sharp),
            label: 'Configuração',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
