import 'dart:math';

void main() {
  const raio = 10.0;
  const anguloGraus = 60.0;

  const anguloRadianos = anguloGraus * pi / 180;
  final x = raio * cos(anguloRadianos);
  final y = raio * sin(anguloRadianos);

  print('Raio: ${raio.toStringAsFixed(2)}');
  print('Ângulo em graus: ${anguloGraus.toStringAsFixed(2)}°');
  print('Ângulo em radianos: ${anguloRadianos.toStringAsFixed(4)}');
  print('Coordenada X: ${x.toStringAsFixed(4)}');
  print('Coordenada Y: ${y.toStringAsFixed(4)}');
}
