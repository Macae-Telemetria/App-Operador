class BluetoothServiceMap {
  static String stationServiceId = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static String stationServiceName = 'Serviços da Estação';

  static String configCharacteristicId = 'beb5483e-36e1-4688-b7f5-ea07361b26a8';
  static String configCharacteristicName = 'Arquivo de configuração';

  static String healthCheckCharacteristicId =
      '7c4c8722-8b05-4cca-b5d2-05ec864f90ee';

  loadConfig(String payload) async {
    print("StationService: (loadConfig) = ${payload}");
  }
}
