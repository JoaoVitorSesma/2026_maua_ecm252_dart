void main() {
  const horaInicial = 8;
  const minutoInicial = 37;
  const segundoInicial = 45;

  const horaFinal = 15;
  const minutoFinal = 12;
  const segundoFinal = 18;

  const inicioEmSegundos =
      horaInicial * 3600 + minutoInicial * 60 + segundoInicial;
  const fimEmSegundos = horaFinal * 3600 + minutoFinal * 60 + segundoFinal;
  const intervalo = fimEmSegundos - inicioEmSegundos;

  const horas = intervalo ~/ 3600;
  const minutos = intervalo % 3600 ~/ 60;
  const segundos = intervalo % 60;

  print('$horas horas, $minutos minutos e $segundos segundos');
}
