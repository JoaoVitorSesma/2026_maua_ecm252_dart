void main() {
  const nome = 'Ana';
  const sobrenome = 'Silva';
  const idade = 18;
  const nomeCompleto = '$nome $sobrenome';
  const soma = 2 + 2;

  // final pode receber um valor conhecido somente durante a execução.
  final horario = DateTime.now();

  // var é usado quando o valor precisa mudar.
  var acessos = 1;
  acessos++;

  print(nomeCompleto);
  print('Idade: $idade');
  print('Soma constante: $soma');
  print('Horário obtido em execução: $horario');
  print('Acessos: $acessos');
}
