import 'dart:convert';

class MqqtConfig {
  String server;
  String port;
  String username;
  String password;
  String topic;
  MqqtConfig(
    this.server,
    this.username,
    this.password,
    this.port,
    this.topic,
  );

  factory MqqtConfig.fromString(String mqttConnectionString) {
    RegExp regex = RegExp(r'mqtt://([^:]+):([^@]+)@([^:]+):(\d+)');
    Match match = regex.firstMatch(mqttConnectionString) as Match;
    String username ="";
    String password= "";
    String server= "";
    String port = "";
    if (match != null) {
      username = match.group(1) ?? "";
      password = match.group(2) ?? "";
      server = match.group(3) ?? "";
      port = match.group(4) ?? "";
    }
    return MqqtConfig(server, username, password, port, "");
  }

  setTopic(String t){
    this.topic = t;
  }

  @override
  String toString() {
    return "mqtt://$username:$password@$server:${int.parse(port)}";
  }
}

class ConfigData {
  String uid;
  String slug;
  String wifiSsid;
  String wifiPassword;
  MqqtConfig mqqtConfig;
  MqqtConfig mqqtV2Config;
  String readInterval;

  ConfigData(
      this.uid,
      this.slug,
      this.wifiSsid,
      this.wifiPassword,
      this.mqqtConfig,
      this.mqqtV2Config,
      this.readInterval);

  @override
  String toString() {
    return "id: $uid, slug: $slug";
  }

  String toJson() {
    Map data = {
      'UID': uid,
      'SLUG': slug,
      'WIFI_SSID': wifiSsid,
      'WIFI_PASSWORD': wifiPassword,
      'MQTT_HOST_V1': mqqtConfig.toString(),
      'MQTT_HOST_v2': mqqtV2Config.toString(),
      'MQTT_TOPIC': mqqtConfig.topic,
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
