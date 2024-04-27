import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/controller/bluetooth-controller.dart';
import 'package:flutter_sit_operation_application/src/contexts/global.dart';
import 'package:flutter_sit_operation_application/src/login/login_controller.dart';
import 'package:flutter_sit_operation_application/src/login/login_service.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController(SettingsService());
  final bluetoothController = BluetoothController();
  final loginController = LoginController(LoginService());

  await settingsController.loadSettings();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => GlobalContext()),
      ],
      child: MyApp(
      loginController: loginController,
      settingsController: settingsController,
          bluetoothController: bluetoothController)));
}
