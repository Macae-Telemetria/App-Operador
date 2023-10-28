import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultScreen extends StatelessWidget {
  final List<ScanResult> scanResult;
  final Function onCancel;
  final Future<void> Function(BluetoothDevice device) onSubmit;

  const ScanResultScreen(
      {super.key,
      required this.scanResult,
      required this.onSubmit,
      required this.onCancel});

  void _handleSubmit(device) async {
    var succeded = await onSubmit(device);
    // print('ConfigView: resultado aqui ${succeded}');
  }

  void _handleCancel() async {
    var succeded = await onCancel();
    // Navigator.pop(context); // Pop the current route
    // print('ConfigView: resultado aqui ${succeded}');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: ModalRoute.of(context)!.animation!,
        builder: (context, child) {
          return Transform.scale(
            scale: ModalRoute.of(context)!.animation!.value,
            child: Opacity(
              opacity: ModalRoute.of(context)!.animation!.value,
              child: Center(
                child: FittedBox(
                  child: Container(
                    margin: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          16), // Adjust the radius as needed
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              12), // Adjust the radius as needed
                          child: Image.asset(
                            "assets/images/station.jpg",
                            height:
                                220, // Adjust the height as per your requirement
                          ),
                        ),
                        const SizedBox(height: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align text to the left
                          children: [
                            const Text(
                              "Estação encontrada!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "MAC: ${scanResult[0].device.remoteId}",
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Nome: ${scanResult[0].device.platformName}",
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Sinal: ${scanResult[0].rssi}",
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),
                        // _renderScanResult(context, scanResult),

                        ElevatedButton(
                          onPressed: () => _handleSubmit(scanResult[0].device),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 219, 54, 39),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  28.0), // Button border radius
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 64.0,
                                vertical: 14.0), // Button padding
                          ),
                          child: const Text(
                            'Conectar-se',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _handleCancel,
                          child: Text(
                            'Voltar',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
