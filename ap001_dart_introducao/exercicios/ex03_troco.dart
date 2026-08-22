void main() {
  const valor = 387;
  var restante = valor;

  final notas100 = restante ~/ 100;
  restante %= 100;
  final notas50 = restante ~/ 50;
  restante %= 50;
  final notas20 = restante ~/ 20;
  restante %= 20;
  final notas10 = restante ~/ 10;
  restante %= 10;
  final notas5 = restante ~/ 5;
  restante %= 5;
  final notas2 = restante ~/ 2;
  restante %= 2;
  final moedas1 = restante;

  print('Troco para R\$ $valor:');
  print('Notas de R\$ 100: $notas100');
  print('Notas de R\$ 50: $notas50');
  print('Notas de R\$ 20: $notas20');
  print('Notas de R\$ 10: $notas10');
  print('Notas de R\$ 5: $notas5');
  print('Notas de R\$ 2: $notas2');
  print('Moedas de R\$ 1: $moedas1');
}
