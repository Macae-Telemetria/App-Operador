import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-station/healthcheck.view.dart';
import 'package:flutter_sit_operation_application/src/home_page/bl-station/health-check-services.dart';

class HealthCheckScreen extends StatefulWidget {
  HealthCheckScreen({Key? key, required this.service}) : super(key: key);
  final BluetoothService? service;

  @override
  State<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends State<HealthCheckScreen> {
  final YourHealthCheckService healthCheckService = YourHealthCheckService();

  Future<void> loadServices() async {
    print("HealthCheckScreen: Novo serviço aqui");
    if (widget.service == null) return;
    // healthCheckService.startFetching(widget.service!);
    return;
  }

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  @override
  void dispose() {
    print("fechando aqui");
    healthCheckService.stopFetching();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamBuilder<HealthCheck?>(
            stream: healthCheckService.healthCheckStream,
            initialData: null,
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) return const Text("Carregando...");
              return HealthChecklView(snapshot.data!);
            }),
      ],
    );
  }
}
