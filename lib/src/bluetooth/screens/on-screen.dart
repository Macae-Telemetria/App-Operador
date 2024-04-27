import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/controller/bluetooth-controller.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/controller/sound-controller.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/scan-result.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/bluetooth-device-screen.dart';
import 'package:flutter_sit_operation_application/src/shared/styles.dart';
import 'package:flutter_sit_operation_application/src/widgets/device-tile.dart';
import 'package:flutter_sit_operation_application/src/widgets/floating-search-button.dart';

class BluetoothOnScreen extends StatefulWidget {
  final BluetoothController controller;

  const BluetoothOnScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  State<BluetoothOnScreen> createState() => _BluetoothOnScreenState();
}

class _BluetoothOnScreenState extends State<BluetoothOnScreen> {
  final SoundController soundController = SoundController();

  bool _isModalOpen = false;

  renderSearchLoading() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(
            "assets/images/bluetooth-sync.gif",
          ),
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(80),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  void _showModal(BuildContext context, result) {
    if (!_isModalOpen) {
      _isModalOpen = true;

      // soundController.play('assets/sounds/success.mp3');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ScanResultScreen(
              scanResult: result,
              onCancel: () {
                Navigator.pop(context); // Close the modal
                _isModalOpen = false; // Update flag when modal is closed
              },
              onSubmit: (device) async {
                try {
                  await widget.controller.connectDevice(context, device);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Conectado com sucesso!"),
                  ));
                } catch (error) {
                  print('Não foi possivel');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Não foi possivel estabelecer Conexão."),
                  ));
                } finally {
                  Navigator.pop(context); // Close the modal
                  _isModalOpen = false; // Update flag when modal is closed
                }
              },
            );
          },
        );
      });
    }
  }

  List<Widget> _renderScanResult(context, List<ScanResult> scanResult) {
    if (scanResult.isEmpty) return [];

    print("3D: ${scanResult}");

    onPress(BluetoothDevice device) async {
      try {
        await widget.controller.connectDevice(context, device);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Conectado com sucesso!"),
        ));

        widget.controller.scanResults.value = [];
      } catch (error) {
        print('Não foi possivel');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Não foi possivel estabelecer Conexão."),
        ));
      }
    }

    var devices = (scanResult).map((s) => s.device);
    return devices
        .map((device) => DeviceTile(
            name: device.platformName,
            subtitle: device.remoteId.toString(),
            isconnected: false,
            onTap: () => onPress(device)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor, // Set the background color
        title: const Text(
          "GPICM Operador",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: ValueListenableBuilder<BluetoothDevice?>(
            valueListenable: widget.controller.connectedDevice,
            builder: (context, device, child) {
              if (device == null) {
                return ValueListenableBuilder<List<ScanResult>>(
                    valueListenable: widget.controller.scanResults,
                    builder: (context, result, child) {
                      return StreamBuilder<bool>(
                          stream: FlutterBluePlus.isScanning,
                          initialData: false,
                          builder: (c, snapshot) {
                            bool isScanning = snapshot.data ?? false;

                            if (!isScanning && result.isNotEmpty) {
                              soundController.play('success.mp3');
                              return Column(children: [
                                ..._renderScanResult(context, result),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () {
                                    widget.controller.scanResults.value = [];
                                  },
                                  child: Text('Voltar',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black45)),
                                ),
                              ]);
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: isScanning
                                        ? renderSearchLoading()
                                        : FloatingSearchButton(
                                            isRunning: snapshot.data!,
                                            onStart: () {
                                              widget.controller.scan();
                                            },
                                            onStop:
                                                widget.controller.stopScan)),
                              ],
                            );
                          });
                    });
              }
              return FutureBuilder<bool>(
                  future: widget.controller.discoverServices(device),
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return DeviceScreen(device: device);
                    } else {
                      return const Text('Não é uma estação valida!');
                    }
                  });
            }),
      ),
    );
  }
}
