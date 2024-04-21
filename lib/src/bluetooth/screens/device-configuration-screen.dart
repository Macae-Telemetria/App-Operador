/* bt disabled */
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/fragments/config-view.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/services/config-services.dart';
import 'package:flutter_sit_operation_application/src/shared/styles.dart';
import 'package:flutter_sit_operation_application/src/widgets/loading-dialog.dart';

class DeviceConfigurationScreen extends StatefulWidget {
  final BluetoothDevice device;
  final ConfigService configService;

  DeviceConfigurationScreen({super.key, required this.device})
      : configService = ConfigService(device: device);

  @override
  State<DeviceConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<DeviceConfigurationScreen> {
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

  Future<bool> _handleSubmit(config) async {
    await widget.configService.writeConfigData(config);
    Navigator.of(context).pop();
    return true;
  }

  Future<bool> _handleRestartSubmit() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const LoadingDialog(
            title: "Reiniciando...",
          );
        });

    await widget.configService.restartBoard().then((_) {
      Navigator.of(context).pop();
    });
    return true;
  }

  Future<bool> _handleBleShutdown() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const LoadingDialog(
            title: "Desligando Bluetooth...",
          );
        });
    await widget.configService.shutDownBle().then((_) {
      Navigator.of(context).pop();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        FutureBuilder(
            future: widget.configService.loadConfigData(),
            initialData: null,
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfigView(
                                  config: (snapshot.data!),
                                  onSubmit: _handleSubmit)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              14.0), // Button border radius
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 22.0), // Button padding
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 28),
                          Icon(Icons.settings, color: Colors.white, size: 36),
                          SizedBox(width: 20),
                          Text("Atualizar configuração",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: _handleRestartSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              14.0), // Button border radius
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0), // Button padding
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 28),
                          Icon(Icons.restart_alt_outlined,
                              color: Colors.white, size: 36),
                          SizedBox(width: 20),
                          Text("Reiniciar",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: _handleBleShutdown,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 211, 40, 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              14.0), // Button border radius
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0), // Button padding
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 28),
                          Icon(Icons.bluetooth_disabled_rounded,
                              color: Colors.white, size: 36),
                          SizedBox(width: 20),
                          Text("Desativar bluetooth",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            })
      ],
    ));
    // ConfigurationScreen(device: widget.device)
  }
}
