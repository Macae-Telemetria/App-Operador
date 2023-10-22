import 'package:flutter/material.dart';

class HealthTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isconnected;
  final int type;
  final void Function()? onTap;

  const HealthTile(
      {super.key,
      required this.name,
      required this.subtitle,
      required this.onTap,
      required this.isconnected,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle),
        onTap: onTap,
        leading: Icon(
            type == 1
                ? Icons.wifi
                : type == 2
                    ? Icons.cloud
                    : type == 3
                        ? Icons.calendar_today
                        : Icons.computer_outlined,
            size: 28.0),
        trailing: Icon(isconnected ? Icons.lightbulb : Icons.lightbulb,
            color:
                isconnected ? Colors.green : Colors.grey, // Set the color here
            size: 28.0 // Set the size if needed));
            ));
  }
}
