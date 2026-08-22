void main() {
  int estatico = 2;
  print('Tipo estático em execução: ${estatico.runtimeType}');

  dynamic dinamico = 2;
  print('Primeiro tipo dinâmico: ${dinamico.runtimeType}');
  dinamico = 'abc';
  print('Segundo tipo dinâmico: ${dinamico.runtimeType}');
}
