import 'dart:convert';
import 'dart:ffi';

class HealthCheck {
  String softwareVersion;
  int timestamp;
  bool isWifiConnected;
  bool isMqqtConnected;
  int wifiDbm;

  HealthCheck(
    this.softwareVersion,
    this.timestamp,
    this.isWifiConnected,
    this.isMqqtConnected,
    this.wifiDbm,
  );

  @override
  String toString() {
    return "wifiDbm: $wifiDbm, isMqqtConnected: $isMqqtConnected";
  }
}
