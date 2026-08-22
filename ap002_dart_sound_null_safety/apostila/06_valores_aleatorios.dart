import 'dart:math';

void main() {
  final gerador = Random();

  print('Inteiro entre 0 e 5: ${gerador.nextInt(6)}');
  print('Inteiro entre 1 e 10: ${gerador.nextInt(10) + 1}');
  print('Inteiro entre 0 e 100: ${gerador.nextInt(101)}');
  print('Real em [0, 1): ${gerador.nextDouble()}');
  print('Real em [0, 100): ${gerador.nextDouble() * 100}');
  print('Real em [100, 150): ${gerador.nextDouble() * 50 + 100}');
  print('Booleano: ${gerador.nextBool()}');
}
