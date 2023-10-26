import 'package:flutter/material.dart';

class HealthTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isconnected;
  final int type;
  final IconData? icon;
  final void Function()? onTap;

  const HealthTile(
      {super.key,
      required this.name,
      required this.subtitle,
      required this.onTap,
      required this.isconnected,
      required this.type,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle),
        onTap: onTap,
        leading: Icon(icon, size: 28.0),
        trailing: Icon(
            isconnected
                ? Icons.check_circle
                : Icons.check_circle_outline_outlined,
            color:
                isconnected ? Colors.green : Colors.grey, // Set the color here
            size: 32.0 // Set the size if needed));
            ));
  }
}
