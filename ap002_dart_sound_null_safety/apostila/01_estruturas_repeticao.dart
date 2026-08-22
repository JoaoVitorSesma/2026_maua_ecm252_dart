void main() {
  print('for:');
  for (var i = 0; i < 5; i++) {
    print(i);
  }

  print('\nfor-in:');
  const nomes = ['Pedro', 'Maria', 'João'];
  for (final nome in nomes) {
    print(nome);
  }

  print('\nwhile:');
  var contador = 0;
  while (contador <= 3) {
    print('Contador: $contador');
    contador++;
  }

  print('\ndo-while:');
  var valor = 0;
  do {
    print('O valor é $valor');
    valor++;
  } while (valor < 3);
}
