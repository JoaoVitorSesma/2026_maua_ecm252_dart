void main() {
  int a = 5;
  int b = 2;

  print('Soma: ${a + b}');
  print('Subtração: ${a - b}');
  print('Multiplicação: ${a * b}');
  print('Divisão real: ${a / b}');
  print('Divisão inteira: ${a ~/ b}');
  print('Resto: ${a % b}');

  int valor = 2;
  valor += 2;
  valor *= 3;
  print('Operadores compostos: $valor');

  int contador = 2;
  print('Pré-incremento: ${++contador}');
  print('Pós-incremento: ${contador++}');
  print('Valor após o pós-incremento: $contador');
  print('Pré-decremento: ${--contador}');
  print('Pós-decremento: ${contador--}');
  print('Valor após o pós-decremento: $contador');
}
