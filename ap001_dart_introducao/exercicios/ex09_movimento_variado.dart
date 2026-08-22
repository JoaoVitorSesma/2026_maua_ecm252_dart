void main() {
  const velocidadeInicial = 10.0;
  const aceleracao = 2.5;
  const tempo = 8.0;

  const velocidadeFinal = velocidadeInicial + aceleracao * tempo;
  const espacoPercorrido =
      velocidadeInicial * tempo + (aceleracao * tempo * tempo) / 2;
  const velocidadeMedia = (velocidadeInicial + velocidadeFinal) / 2;

  print('Velocidade inicial: ${velocidadeInicial.toStringAsFixed(2)} m/s');
  print('Aceleração: ${aceleracao.toStringAsFixed(2)} m/s²');
  print('Tempo: ${tempo.toStringAsFixed(2)} s');
  print('Velocidade final: ${velocidadeFinal.toStringAsFixed(2)} m/s');
  print('Espaço percorrido: ${espacoPercorrido.toStringAsFixed(2)} m');
  print('Velocidade média: ${velocidadeMedia.toStringAsFixed(2)} m/s');
}
