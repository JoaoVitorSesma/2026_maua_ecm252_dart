void main() {
  int a = 2;
  int b = 3;

  print('a == b: ${a == b}');
  print('a != b: ${a != b}');
  print('a < b: ${a < b}');
  print('a > b: ${a > b}');
  print('a <= b: ${a <= b}');
  print('a >= b: ${a >= b}');
  print("'abc' == 'abc': ${'abc' == 'abc'}");

  final agora = DateTime.now();
  var temIngresso = agora.weekday <= 5;
  var portoesAbertos = agora.hour >= 8;
  print('Pode entrar: ${temIngresso && portoesAbertos}');
  print('Há alguma condição válida: ${temIngresso || portoesAbertos}');
  print('Portões não estão abertos: ${!portoesAbertos}');
}
