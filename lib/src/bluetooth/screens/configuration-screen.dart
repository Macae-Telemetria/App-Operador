/* bt disabled */
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/fragments/config-view.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/config-services.dart';

class ConfigurationScreen extends StatefulWidget {
  final BluetoothDevice device;
  final ConfigService configService;

  ConfigurationScreen({super.key, required this.device})
      : configService = ConfigService(device: device);

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  @override
  void initState() {
    print("ConfigurationScreen: Iniciado");
    super.initState();
  }

  @override
  void dispose() {
    print("ReportsScreen: vamos fazer um dispose");
    widget.configService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.configService.loadConfigData(),
        initialData: null,
        builder: (BuildContext context, snapshot) {
          print("ConfigurationScreen: snapshot");
          print("ConfigurationScreen: ${snapshot.data}");
          if (snapshot.data == null) {
            return const Text("Carregando...");
          }
          return ConfigView(
              config: (snapshot.data!),
              onSubmit: (config) async {
                return true;
              });
        });
  }
}
