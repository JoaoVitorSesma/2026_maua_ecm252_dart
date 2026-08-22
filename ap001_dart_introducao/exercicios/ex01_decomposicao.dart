void main() {
  const numero = 5837;

  final milhar = numero ~/ 1000;
  final centena = numero % 1000 ~/ 100;
  final dezena = numero % 100 ~/ 10;
  final unidade = numero % 10;

  print('Número: $numero');
  print('Milhar: $milhar');
  print('Centena: $centena');
  print('Dezena: $dezena');
  print('Unidade: $unidade');
}
