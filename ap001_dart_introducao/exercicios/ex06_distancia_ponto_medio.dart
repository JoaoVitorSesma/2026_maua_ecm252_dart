import 'dart:math';

void main() {
  const x1 = 1.0;
  const y1 = 2.0;
  const x2 = 7.0;
  const y2 = 10.0;

  final diferencaX = x2 - x1;
  final diferencaY = y2 - y1;
  final distancia = sqrt(
    diferencaX * diferencaX + diferencaY * diferencaY,
  );
  const pontoMedioX = (x1 + x2) / 2;
  const pontoMedioY = (y1 + y2) / 2;

  print('Ponto A: ($x1, $y1)');
  print('Ponto B: ($x2, $y2)');
  print('Distância: ${distancia.toStringAsFixed(2)}');
  print('Ponto médio: ($pontoMedioX, $pontoMedioY)');
}
