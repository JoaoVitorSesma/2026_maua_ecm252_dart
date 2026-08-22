void main() {
  const numero = 527;

  final centena = numero ~/ 100;
  final dezena = numero % 100 ~/ 10;
  final unidade = numero % 10;
  final invertido = unidade * 100 + dezena * 10 + centena;

  print('Número original: $numero');
  print('Número invertido: $invertido');
}
