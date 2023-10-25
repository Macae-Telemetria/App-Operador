/* bt disabled */
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/health-check-services.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-station/healthcheck.view.dart';

class ReportsScreen extends StatefulWidget {
  final BluetoothDevice device;
  final HealthCheckService healthCheckService;

  ReportsScreen({super.key, required this.device})
      : healthCheckService = HealthCheckService(device: device);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    print("ReportsScreen: Iniciado");
    super.initState();
  }

  @override
  void dispose() {
    print("ReportsScreen: vamos fazer um dispose");
    widget.healthCheckService.stopFetching();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: widget.healthCheckService.startFetching(),
            initialData: false,
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == false)
                return const Text("Carregando caracteristica");
              return StreamBuilder<HealthCheck?>(
                  stream: widget.healthCheckService.healthCheckStream,
                  initialData: null,
                  builder: (BuildContext context, subSnapshot) {
                    print("DeviceScreen: snapshot");
                    print("DeviceScreen: ${subSnapshot.data}");
                    if (subSnapshot.data == null) {
                      return const Text("Aguardando proximo...");
                    }
                    return HealthChecklView(subSnapshot.data!);
                  });
            }));
  }
}
