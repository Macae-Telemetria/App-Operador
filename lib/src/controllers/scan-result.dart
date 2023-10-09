// ignore: file_names
class ScannedDevice {
  String id;
  String name;
  String type;

  ScannedDevice(this.id, this.name, this.type);

  @override
  String toString() {
    return "id: ${id ?? "Sem ide"}, name: $name";
  }
}
