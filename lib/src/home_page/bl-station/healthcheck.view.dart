import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/domain/health-check.dart';
import 'package:flutter_sit_operation_application/src/widgets/health-tile.dart';
import 'package:get/state_manager.dart';

class HealthChecklView extends StatelessWidget {
  final HealthCheck healthCheck;

  HealthChecklView(this.healthCheck);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HealthTile(
              name: "Wifi:",
              subtitle: healthCheck.isWifiConnected
                  ? 'Conectado (${healthCheck.wifiDbm} dbm)'
                  : "Desconectado",
              isconnected: healthCheck.isWifiConnected,
              type: 1,
              icon: Icons.wifi,
              onTap: () {}),
          HealthTile(
              name: "Mqqt:",
              subtitle:
                  healthCheck.isMqqtConnected ? 'Conectado' : "Desconectado",
              isconnected: healthCheck.isMqqtConnected,
              onTap: () {},
              icon: Icons.cloud,
              type: 2),
          HealthTile(
              name: "Timestamp:",
              subtitle: healthCheck.timestamp.toString(),
              isconnected: healthCheck.timestamp > 1697508328 ? true : false,
              onTap: () {},
              icon: Icons.calendar_today,
              type: 3),
          HealthTile(
              name: "Versão software:",
              subtitle: 'V${healthCheck.softwareVersion}',
              isconnected: true,
              onTap: () {},
              icon: Icons.computer_outlined,
              type: 5),
          HealthTile(
              name: "Proxima medição:",
              subtitle: '${(healthCheck.timeRemaining / 1000).ceil()}s',
              isconnected: true,
              onTap: () {},
              icon: Icons.timer,
              type: 5),
        ],
      ),
    );
  }
}
