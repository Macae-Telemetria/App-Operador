import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sit_operation_application/src/controllers/station-service.dart';
import 'package:flutter_sit_operation_application/src/domain/config-file.dart';
import 'package:flutter_sit_operation_application/src/home_page/config-view.dart';

class StationDeviceScreen extends StatefulWidget {
  final Function onReadValues;

  StationDeviceScreen(
      {Key? key, required this.device, required this.onReadValues})
      : super(key: key);

  final BluetoothDevice device;

  @override
  State<StationDeviceScreen> createState() => _StationDeviceScreenState();
}

class _StationDeviceScreenState extends State<StationDeviceScreen> {
  ConfigData? _config = null;

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  void loadConfig() async {
    print('Trying to load config file');
    setState(() {
      _config = null;
    });
    List<BluetoothService> services = await widget.device.discoverServices();
    BluetoothService stationService = services.firstWhere((service) {
      return service.uuid == Guid(StationService.stationServiceId);
    });

    BluetoothCharacteristic configCharacteristic =
        stationService.characteristics.firstWhere((characteristic) {
      return characteristic.uuid == Guid(StationService.configCharacteristicId);
    });

    print('**** Lendo Configureção inicial ${configCharacteristic.uuid}\n');
    var sub = configCharacteristic.value.listen((value) {
      print("Novo Valor lido aqui dentro: ${value}");

      if (value.isEmpty) return;

      String configJson = String.fromCharCodes(value);

      Map configMap = json.decode(configJson);
      print("Baixado ${configMap}");
      // return json.encode(data);

      ConfigData incommingConfig = ConfigData(
          configMap['STATION_UID'] ?? "",
          configMap['STATION_NAME'] ?? "",
          configMap['WIFI_SSID'] ?? "",
          configMap['WIFI_PASSWORD'] ?? "",
          configMap['MQTT_SERVER'] ?? "",
          configMap['MQTT_USERNAME'] ?? "",
          configMap['MQTT_PASSWORD'] ?? "",
          configMap['MQTT_TOPIC'] ?? "",
          configMap['MQTT_PORT'].toString(),
          configMap['INTERVAL'].toString());

      print("converted config: ${incommingConfig}");

      setState(() {
        _config = incommingConfig;
      });
    });

    await configCharacteristic.read();
    // sub.cancel();
  }

  Future<bool> submitConfig(ConfigData newConfig) async {
    print('Trying to submit new config : ${newConfig}');

    List<BluetoothService> services = await widget.device.discoverServices();
    BluetoothService stationService = services.firstWhere((service) {
      return service.uuid == Guid(StationService.stationServiceId);
    });

    BluetoothCharacteristic configCharacteristic =
        stationService.characteristics.firstWhere((characteristic) {
      return characteristic.uuid == Guid(StationService.configCharacteristicId);
    });

    print('**** Enviando nova Configureção ${configCharacteristic.uuid}\n');

    List<int> result = _config == null ? [] : newConfig!.toBuffer();
    configCharacteristic.write(result);
    return true;
  }

  Widget _buildReadWriteNotifyButton(
      Guid serviceId, BluetoothCharacteristic charac) {
    List<ButtonTheme> buttons = [];

    if (charac.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: Text('READ', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                var sub = charac.value.listen((value) {
                  print("Novo Valor lido: ${value}");
                  widget.onReadValues(serviceId, charac.uuid, value);
                });
                await charac.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (charac.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: () {
                // charac.write(value)
                List<int> result = _config == null ? [] : _config!.toBuffer();
                charac.write(result);
              },
            ),
          ),
        ),
      );
    }
    if (charac.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () {},
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Text(charac.uuid.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(children: [...buttons]),
      ],
    );
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    List<BluetoothService> availableServices = services.where((service) {
      return service.uuid == Guid(StationService.stationServiceId);
    }).toList();

    String serviceName = StationService.stationServiceName;

    return availableServices
        .map(
          (s) => Column(
            children: [
              ListTile(title: Text(serviceName)),
              Column(
                children: s.characteristics
                    .map((c) => _buildReadWriteNotifyButton(s.uuid, c))
                    .toList(),
              )
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.device.name}"),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => widget.device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => widget.device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: widget.device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => Column(
                children: [
                  ListTile(
                    leading: (snapshot.data == BluetoothDeviceState.connected)
                        ? Icon(Icons.bluetooth_connected)
                        : Icon(Icons.bluetooth_disabled),
                    title: Text(
                        'Dispositivo está ${snapshot.data.toString().split('.')[1]}.'),
                    subtitle: Text('${widget.device.id}'),
                    trailing: StreamBuilder<bool>(
                      stream: widget.device.isDiscoveringServices,
                      initialData: false,
                      builder: (c, snapshot) => IndexedStack(
                        index: snapshot.data! ? 1 : 0,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () => widget.device.discoverServices(),
                          ),
                          IconButton(
                            onPressed: () {
                              loadConfig();
                            },
                            icon: const SizedBox(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.grey),
                              ),
                              width: 18.0,
                              height: 18.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (_config == null)
                    const Text('Carregando...')
                  else
                    ConfigView(
                      config: (_config as ConfigData),
                      onSubmit: submitConfig,
                    ),
                ],
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: widget.device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
