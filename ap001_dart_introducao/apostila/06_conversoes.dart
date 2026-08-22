void main() {
  String idadeTextual = '25';
  int idade = int.parse(idadeTextual);

  String pesoTextual = '85.2';
  double peso = double.parse(pesoTextual);

  String alturaTextual = '1.8';
  num altura = num.parse(alturaTextual);

  int inteiro = 2;
  double real = inteiro.toDouble();
  double valor = 1.2;

  print('Idade: $idade');
  print('Peso: $peso');
  print('Altura: $altura');
  print('Inteiro convertido para double: $real');
  print('Arredondamento: ${valor.round()}');
  print('Teto: ${valor.ceil()}');
  print('Chão: ${valor.floor()}');
}
