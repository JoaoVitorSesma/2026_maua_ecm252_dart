import '../lib/pedra_papel_tesoura.dart';

void verifica(bool condicao, String descricao) {
  if (!condicao) {
    throw StateError('Falhou: $descricao');
  }
}

void verificaLanca(void Function() acao, String descricao) {
  try {
    acao();
  } on ArgumentError {
    return;
  }

  throw StateError('Falhou: $descricao');
}

void main() {
  verifica(parseOpcao('1') == 1, 'converte uma opção numérica');
  verifica(parseOpcao(' 4 ') == 4, 'ignora espaços externos');
  verifica(parseOpcao('texto') == null, 'recusa texto não numérico');
  verifica(parseOpcao(null) == null, 'aceita entrada ausente');

  verifica(opcaoEhValida(1), 'aceita o limite inferior');
  verifica(opcaoEhValida(4), 'aceita o limite superior');
  verifica(!opcaoEhValida(0), 'recusa valor abaixo do intervalo');
  verifica(!opcaoEhValida(5), 'recusa valor acima do intervalo');
  verifica(!opcaoEhValida(null), 'recusa valor ausente');

  verifica(mapeiaOpcao(1) == Opcao.pedra, 'mapeia pedra');
  verifica(mapeiaOpcao(2) == Opcao.papel, 'mapeia papel');
  verifica(mapeiaOpcao(3) == Opcao.tesoura, 'mapeia tesoura');
  verifica(mapeiaOpcao(4) == Opcao.sair, 'mapeia sair');
  verificaLanca(() => mapeiaOpcao(0), 'recusa opção fora do intervalo');

  verifica(
    decideResultado(Opcao.pedra, Opcao.pedra) == 'Empate',
    'identifica empate',
  );
  verifica(
    decideResultado(Opcao.pedra, Opcao.tesoura) == 'Você venceu',
    'pedra vence tesoura',
  );
  verifica(
    decideResultado(Opcao.papel, Opcao.pedra) == 'Você venceu',
    'papel vence pedra',
  );
  verifica(
    decideResultado(Opcao.tesoura, Opcao.papel) == 'Você venceu',
    'tesoura vence papel',
  );
  verifica(
    decideResultado(Opcao.pedra, Opcao.papel) == 'Computador venceu',
    'pedra perde de papel',
  );
  verificaLanca(
    () => decideResultado(Opcao.sair, Opcao.pedra),
    'recusa a opção sair em uma rodada',
  );

  verifica(
    verificaVencedorPartida(
          vitoriasUsuario: 2,
          vitoriasComputador: 2,
        ) ==
        null,
    'mantém a partida enquanto ninguém alcançou três vitórias',
  );
  verifica(
    verificaVencedorPartida(
          vitoriasUsuario: 3,
          vitoriasComputador: 1,
        ) ==
        VencedorPartida.usuario,
    'declara o usuário vencedor ao chegar a três vitórias',
  );
  verifica(
    verificaVencedorPartida(
          vitoriasUsuario: 2,
          vitoriasComputador: 3,
        ) ==
        VencedorPartida.computador,
    'declara o computador vencedor ao chegar a três vitórias',
  );

  print('Todos os testes passaram.');
}
