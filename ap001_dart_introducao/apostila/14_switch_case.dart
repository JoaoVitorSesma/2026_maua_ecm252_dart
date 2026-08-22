void main() {
  const nota = 9;

  switch (nota) {
    case 10 || 9:
      print('Conceito A');
    case 8:
      print('Conceito B');
    case 7:
      print('Conceito C');
    case 6:
      print('Conceito D');
    case 5:
      print('Conceito E');
    default:
      print('Conceito R');
  }

  const mediaFinal = 7;
  final conceito = switch (mediaFinal) {
    10 || 9 => 'A',
    8 => 'B',
    7 => 'C',
    6 => 'D',
    5 => 'E',
    _ => 'R',
  };
  print('Switch expression: $conceito');

  const vaiChover = 'Sim';
  switch (vaiChover) {
    case 'Sim':
      print('Leve guarda-chuva');
    default:
      print('Não leve guarda-chuva');
  }

  const temperatura = 9.7;
  switch (temperatura) {
    case > 9 && <= 10:
      print('Faixa A');
    case > 8 && <= 9:
      print('Faixa B');
    default:
      print('Outra faixa');
  }

  const frutas = ['banana', 'laranja'];
  switch (frutas) {
    case ['banana', 'laranja']:
      print('Banana e laranja');
    case ['banana', 'maçã']:
      print('Banana e maçã');
    default:
      print('Combinação desconhecida');
  }
}
