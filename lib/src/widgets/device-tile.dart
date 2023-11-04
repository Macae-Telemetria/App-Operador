import 'package:flutter/material.dart';
import 'package:get/utils.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(name,
            style:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
        onTap: onTap,
        leading: Container(
            child: Icon(!isconnected
                ? Icons.bluetooth_disabled_outlined
                : Icons.bluetooth_connected)),
      ),
    );
  }
}
