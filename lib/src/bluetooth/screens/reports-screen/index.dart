/* bt disabled */
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/fragments/healcheck-view.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/fragments/metrics-view.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/health-check-services.dart';
import 'package:flutter_sit_operation_application/src/domain/Metrics.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';

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
    return Column(
      children: [
        FutureBuilder<bool>(
            future: widget.healthCheckService.startFetching(),
            initialData: false,
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == false) {
                return const CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 6,
                );
              }
              return Column(
                children: [
                  ValueListenableBuilder<HealthCheck?>(
                      valueListenable: widget.healthCheckService.dataNotifier,
                      builder: (context, value, child) {
                        if (value == null) {
                          return const CircularProgressIndicator();
                        }
                        return HealthChecklView(value);
                      }),
                  const Divider(
                    // Este é o Divider
                    color: Colors.grey, // Cor da linha
                    height: 50, // Altura da linha
                    thickness: 2, // Espessura da linha
                    indent: 20, // Recuo à esquerda
                    endIndent: 20, // Recuo à direita
                  ),
                  SizedBox(height: 32),
                  ValueListenableBuilder<Metrics?>(
                      valueListenable:
                          widget.healthCheckService.metricsNotifier,
                      builder: (context, value, child) {
                        if (value == null) {
                          return const Column(
                            children: [
                              Text("Aguarando proxima medição"),
                              SizedBox(height: 32),
                              CircularProgressIndicator(),
                            ],
                          );
                        }
                        return MetricsView(value);
                      })
                ],
              );
            }),
      ],
    );
  }
}
