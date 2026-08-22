void main() {
  const nota1 = 8.0;
  const nota2 = 6.5;
  const nota3 = 7.5;
  const peso1 = 2;
  const peso2 = 3;
  const peso3 = 5;

  const somaPesosIniciais = peso1 + peso2 + peso3;
  const somaPonderada = nota1 * peso1 + nota2 * peso2 + nota3 * peso3;
  const mediaPonderada = somaPonderada / somaPesosIniciais;

  const pesoQuartaAvaliacao = 4;
  const mediaFinalDesejada = 7.0;
  const somaPesosFinal = somaPesosIniciais + pesoQuartaAvaliacao;
  const notaNecessaria =
      (mediaFinalDesejada * somaPesosFinal - somaPonderada) /
      pesoQuartaAvaliacao;

  print(
    'Média ponderada das três atividades: ${mediaPonderada.toStringAsFixed(2)}',
  );
  print(
    'Nota necessária na quarta avaliação: ${notaNecessaria.toStringAsFixed(2)}',
  );
}
