import 'dart:convert';

class HealthCheck {
  String softwareVersion;
  int timestamp;
  bool isWifiConnected;
  bool isMqqtConnected;
  int wifiDbm;
  int timeRemaining;

  HealthCheck(
    this.softwareVersion,
    this.timestamp,
    this.isWifiConnected,
    this.isMqqtConnected,
    this.wifiDbm,
    this.timeRemaining,
  );

  @override
  String toString() {
    Map data = {
      'softwareVersion': softwareVersion,
      'timestamp': timestamp,
      'isWifiConnected': isWifiConnected,
      'isMqqtConnected': isMqqtConnected,
      'wifiDbm': wifiDbm,
      'timeRemaining': timeRemaining
    };

    return json.encode(data);
  }
}
