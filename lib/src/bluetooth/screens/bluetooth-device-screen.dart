import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/configuration-screen.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/metrics-screen/index.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/reports-screen/index.dart';
import 'package:flutter_sit_operation_application/src/widgets/loading-dialog.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<BluetoothConnectionState>(
                stream: widget.device.connectionState,
                initialData: BluetoothConnectionState.connected,
                builder: (c, snapshot) {
                  var state = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: (state == BluetoothConnectionState.connected)
                              ? const Icon(Icons.bluetooth_connected)
                              : const Icon(Icons.bluetooth_disabled),
                          title: Text('${state.toString().split('.')[1]}.'),
                          subtitle: Text('${widget.device.remoteId}'),
                          trailing: ElevatedButton(
                            child: const Text('Descontetar'),
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) {
                                    return const LoadingDialog(
                                      title: "Desconectando",
                                    );
                                  });

                              widget.device.disconnect().then((_) {
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ),
                      ),
                      IndexedStack(
                        index: _currentIndex,
                        children: [
                          (_currentIndex == 0)
                              ? ReportsScreen(device: widget.device)
                              : const Text('Não carregado.'),
                          (_currentIndex == 2)
                              ? ConfigurationScreen(device: widget.device)
                              : const Text('Não carregado.'),
                        ],
                      )
                    ],
                  );
                }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_sharp),
            label: 'Saude',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_sharp),
            label: 'Configuração',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
