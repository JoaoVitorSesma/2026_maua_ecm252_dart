void main() {
  var vaiChover = DateTime.now().month == 1;
  String levarGuardaChuva = vaiChover ? 'SIM!' : 'NÃO';

  int idade = 17;
  String podeDirigir = idade >= 18 ? 'SIM!' : 'NÃO';

  print('Levar guarda-chuva? $levarGuardaChuva');
  print('Pode dirigir? $podeDirigir');
}
