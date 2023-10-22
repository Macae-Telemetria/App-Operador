import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/bluetooth-service-map.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/health-check-services.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-station/healthcheck.view.dart';

class DeviceScreen extends StatelessWidget {
  DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  final HealthCheckService healthCheckService = HealthCheckService();

  Widget _buildHealthCheckService() {
    List<BluetoothService>? availableServices = device.servicesList;
    if (availableServices == null) return Text("Não disponivel");

    BluetoothCharacteristic? hCheckcharacteristic;
    try {
      BluetoothService stationService = availableServices.firstWhere((service) {
        return service.uuid == Guid(BluetoothServiceMap.stationServiceId);
      });

      print("DeviceScreen: Service ${stationService.uuid}");

      hCheckcharacteristic =
          stationService.characteristics.firstWhere((characteristic) {
        return characteristic.uuid ==
            Guid(BluetoothServiceMap.healthCheckCharacteristicId);
      });

      print("DeviceScreen: Characteristic ${hCheckcharacteristic.uuid}");
    } catch (error) {
      print("DeviceScreen: Serviço ou caracteristica não encontrada.");
    }

    if (hCheckcharacteristic == null) return Text("Não disponivel");

    return FutureBuilder(
        future: healthCheckService.startFetching(device, hCheckcharacteristic),
        initialData: false,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == false) return Text("Carregando caracteristica");
          return Text("ok");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<BluetoothConnectionState>(
            stream: device.connectionState,
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
                    subtitle: Text('${device.remoteId}'),
                  ),
                  Text('contectado: ${state}'),
                  _buildHealthCheckService(),
                  StreamBuilder<HealthCheck?>(
                      stream: healthCheckService.healthCheckStream,
                      initialData: null,
                      builder: (BuildContext context, subSnapshot) {
                        print("DeviceScreen: snapshot");
                        print("DeviceScreen: ${subSnapshot.data}");
                        if (subSnapshot.data == null) {
                          return const Text("Aguardando healthcheck...");
                        }
                        return HealthChecklView(subSnapshot.data!);
                      })
                ],
              );
            }),
      ],
    );
  }
}
