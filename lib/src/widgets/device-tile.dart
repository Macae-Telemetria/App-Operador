import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isconnected;
  final void Function()? onTap;

  const DeviceTile(
      {super.key,
      required this.name,
      required this.subtitle,
      required this.onTap,
      required this.isconnected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(subtitle),
      onTap: onTap,
      leading: Icon(!isconnected
          ? Icons.bluetooth_disabled_outlined
          : Icons.bluetooth_connected),
    );
  }
}
