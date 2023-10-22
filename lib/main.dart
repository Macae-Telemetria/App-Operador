import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/controller/bluetooth-controller.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  final bluetoothController = BluetoothController();
  await settingsController.loadSettings();

  runApp(MyApp(
      settingsController: settingsController,
      bluetoothController: bluetoothController));
}
