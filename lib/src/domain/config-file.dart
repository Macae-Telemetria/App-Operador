import 'dart:convert';

class ConfigData {
  String uid;
  String name;
  String wifiSsid;
  String wifiPassword;
  String mqqtServer;
  String mqqtUsername;
  String mqqtPassword;
  String mqqtTopic;
  String mqqtPort;
  String readInterval;

  ConfigData(
      this.uid,
      this.name,
      this.wifiSsid,
      this.wifiPassword,
      this.mqqtServer,
      this.mqqtUsername,
      this.mqqtPassword,
      this.mqqtTopic,
      this.mqqtPort,
      this.readInterval);

  @override
  String toString() {
    return "id: $uid, name: $name";
  }

  String toJson() {
    Map data = {
      'STATION_UID': uid,
      'STATION_NAME': name,
      'WIFI_SSID': wifiSsid,
      'WIFI_PASSWORD': wifiPassword,
      'MQTT_SERVER': mqqtServer,
      'MQTT_USERNAME': mqqtUsername,
      'MQTT_PASSWORD': mqqtPassword,
      'MQTT_TOPIC': mqqtTopic,
      'MQTT_PORT': mqqtPort.isNotEmpty ? int.parse(mqqtPort) : 1883,
      'INTERVAL': readInterval.isNotEmpty ? int.parse(readInterval) : 60000,
    };

    return json.encode(data);
  }

  List<int> toBuffer() {
    String input = toJson();
    List<int> charCodes = [];
    for (int i = 0; i < input.length; i++) {
      int charCode = input.codeUnitAt(i);
      charCodes.add(charCode);
    }
    return charCodes;
  }
}
