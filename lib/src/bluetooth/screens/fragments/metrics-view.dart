import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/domain/Metrics.dart';
import 'package:flutter_sit_operation_application/src/widgets/metric-tile.dart';

class MetricsView extends StatelessWidget {
  final Metrics metrics;

  const MetricsView(this.metrics, {super.key});

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
            subtitle: '${metrics.temperatura ?? 0}C°',
          ),
          MetricTile(
            name: "Umidade:",
            icon: Icons.water,
            onTap: () {},
            subtitle: '${metrics.umidade_ar ?? 0}%',
          ),
          MetricTile(
            name: "Pressão:",
            icon: Icons.thermostat_auto_sharp,
            onTap: () {},
            subtitle: '${metrics.pressao ?? 0}%',
          ),
          MetricTile(
            name: "Chuva Acumulada:",
            icon: Icons.water_drop,
            onTap: () {},
            subtitle: '${metrics.volume_chuva ?? 0} ml',
          ),
          MetricTile(
            name: "Diração do vento:",
            icon: Icons.directions_outlined,
            onTap: () {},
            subtitle: '${metrics.dir_vento ?? "Não identificado"}',
          ),
          MetricTile(
            name: "Velocidade do vento:",
            icon: Icons.wind_power,
            onTap: () {},
            subtitle: '${metrics.velocidade_vento ?? "Não identificado"}',
          ),
          MetricTile(
            name: "Rajada de vento",
            icon: Icons.storm_outlined,
            onTap: () {},
            subtitle: '${metrics.rajada_vento ?? "Não identificado"}',
          ),
          MetricTile(
            name: "Timestamp:",
            icon: Icons.timer,
            onTap: () {},
            subtitle: '${metrics.timestamp ?? "Não identificado"}',
          ),
        ],
      ),
    );
  }
}
