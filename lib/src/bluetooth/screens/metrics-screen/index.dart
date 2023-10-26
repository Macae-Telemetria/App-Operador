import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/fragments/metrics-view.dart';
import 'package:flutter_sit_operation_application/src/domain/Metrics.dart';

class MetricsScreen extends StatefulWidget {
  final BluetoothDevice device;

  const MetricsScreen({super.key, required this.device});

  @override
  State<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends State<MetricsScreen> {
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
    return Column(children: [MetricsView(Metrics())]);
  }
}
