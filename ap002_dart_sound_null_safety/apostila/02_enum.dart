enum DiaSemana { segunda, terca, quarta, quinta, sexta, sabado, domingo }

String mensagemPara(DiaSemana dia) {
  return switch (dia) {
    DiaSemana.segunda => 'Começando a semana.',
    DiaSemana.terca ||
    DiaSemana.quarta ||
    DiaSemana.quinta => 'Semana em andamento.',
    DiaSemana.sexta => 'Sextou!',
    DiaSemana.sabado || DiaSemana.domingo => 'Fim de semana!',
  };
}

void main() {
  print(DiaSemana.values);

  const dia = DiaSemana.sexta;
  print('Nome: ${dia.name}');
  print('Índice: ${dia.index}');
  print(mensagemPara(dia));
}
