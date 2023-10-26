import 'package:flutter/material.dart';

class MetricTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final IconData? icon;
  final void Function()? onTap;

  const MetricTile(
      {super.key,
      required this.name,
      required this.subtitle,
      required this.onTap,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(name, style: const TextStyle(fontSize: 16)),
        onTap: onTap,
        leading: Icon(icon, size: 28.0),
        trailing: Text(
          subtitle,
          style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ));
  }
}
