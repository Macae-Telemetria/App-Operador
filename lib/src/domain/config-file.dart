import 'dart:convert';

class ConfigData {
  String uid; //  "STATION_UID": "02",
  String name; //  "STATION_NAME": "est002",
  String wifiSsid; //  "WIFI_SSID": "Lucas",
  String wifiPassword; //  "WIFI_PASSWORD": "2014072276",
  String mqqtServer; //  "MQTT_SERVER": "telemetria.macae.ufrj.br",
  String mqqtUsername; //  "MQTT_USERNAME": "telemetria",
  String mqqtPassword; //  "MQTT_PASSWORD": "kancvx8thz9FCN5jyq",
  String mqqtTopic; //  "MQTT_TOPIC": "/prefeituras/macae/estacoes/est001",
  String mqqtPort; //  "MQTT_PORT": 1883,
  String readInterval; //  "INTERVAL": 3000

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
      'MQTT_PORT': mqqtPort,
      'INTERVAL': readInterval
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
