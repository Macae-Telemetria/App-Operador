class Metrics {
  int? timestamp;
  double? temperatura;
  double? umidade_ar;
  double? velocidade_vento;
  double? rajada_vento;
  int? dir_vento;
  double? volume_chuva;
  double? pressao;

  Metrics(
      this.timestamp,
      this.temperatura,
      this.umidade_ar,
      this.velocidade_vento,
      this.rajada_vento,
      this.dir_vento,
      this.volume_chuva,
      this.pressao);
}
