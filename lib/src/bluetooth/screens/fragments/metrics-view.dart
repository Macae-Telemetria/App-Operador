import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/domain/Metrics.dart';
import 'package:flutter_sit_operation_application/src/widgets/health-tile.dart';
import 'package:flutter_sit_operation_application/src/widgets/metric-tile.dart';

class MetricsView extends StatelessWidget {
  final Metrics metrics;

  const MetricsView(this.metrics);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MetricTile(
            name: "Temperatura:",
            icon: Icons.thermostat,
            onTap: () {},
            subtitle: '30°',
          ),
          MetricTile(
            name: "Umidade:",
            icon: Icons.water,
            onTap: () {},
            subtitle: '30°',
          ),
          MetricTile(
            name: "Pressão:",
            icon: Icons.thermostat_auto_sharp,
            onTap: () {},
            subtitle: '30°',
          ),
          MetricTile(
            name: "Chuva Acumulada:",
            icon: Icons.water_drop,
            onTap: () {},
            subtitle: '30°',
          ),
          MetricTile(
            name: "Diração do vento:",
            icon: Icons.directions_outlined,
            onTap: () {},
            subtitle: '30°',
          ),
          MetricTile(
            name: "Velocidade do vento:",
            icon: Icons.wind_power,
            onTap: () {},
            subtitle: '30°',
          ),
          MetricTile(
            name: "Rajada de vento",
            icon: Icons.storm_outlined,
            onTap: () {},
            subtitle: '30°',
          ),
          MetricTile(
            name: "Timestamp:",
            icon: Icons.timer,
            onTap: () {},
            subtitle: '30°',
          ),
        ],
      ),
    );
  }
}
