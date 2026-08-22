void main() {
  const distanciaKm = 735.0;
  const velocidadeMedia = 95.0;
  const consumoKmLitro = 11.5;
  const precoLitro = 6.19;

  const tempoHoras = distanciaKm / velocidadeMedia;
  const combustivelLitros = distanciaKm / consumoKmLitro;
  const custoCombustivel = combustivelLitros * precoLitro;

  final horasInteiras = tempoHoras.toInt();
  final minutosRestantes = ((tempoHoras - horasInteiras) * 60).round();

  print('Distância: ${distanciaKm.toStringAsFixed(1)} km');
  print('Tempo estimado: ${tempoHoras.toStringAsFixed(2)} horas');
  print('Tempo aproximado: $horasInteiras h $minutosRestantes min');
  print('Combustível necessário: ${combustivelLitros.toStringAsFixed(2)} L');
  print('Custo de combustível: R\$ ${custoCombustivel.toStringAsFixed(2)}');
}
