/* bt disabled */
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/fragments/config-view.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/config-services.dart';
import 'package:flutter_sit_operation_application/src/widgets/loading-dialog.dart';

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
    widget.configService.dispose();
    super.dispose();
  }

  Future<bool> _handleSubmit(config) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const LoadingDialog(
            title: "Salvando",
            subtitle: "A estação será reiniciada, em seguida.",
          );
        });

    await widget.configService.writeConfigData(config).then((_) {
      Navigator.of(context).pop();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.configService.loadConfigData(),
        initialData: null,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return const CircularProgressIndicator();
          }
          return ConfigView(config: (snapshot.data!), onSubmit: _handleSubmit);
        });
  }
}
