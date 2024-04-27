import 'package:flutter/material.dart';

import 'login_service.dart';


class LoginController with ChangeNotifier {
  LoginController(this._loginService);

  // Make SettingsService a private variable so it is not used directly.
  final LoginService _loginService;
}
