import 'dart:io';
import 'dart:math';

enum Opcao { pedra, papel, tesoura, sair }

enum VencedorPartida { usuario, computador }

const vitoriasNecessarias = 3;
const maximoRodadas = 5;

// exibir menu
void exibe(String texto) {
  stdout.writeln(texto);
}

//
int? parseOpcao(String? entrada) {
  if (entrada == null) {
    return null;
  }

  return int.tryParse(entrada.trim());
}

bool opcaoEhValida(int? opcao) {
  return opcao != null && opcao >= 1 && opcao <= 4;
}

Opcao mapeiaOpcao(int opcao) {
  if (!opcaoEhValida(opcao)) {
    throw RangeError.range(opcao, 1, 4, 'opcao');
  }

  return Opcao.values[opcao - 1];
}

String decideResultado(Opcao opcaoUsuario, Opcao opcaoComputador) {
  if (opcaoUsuario == Opcao.sair || opcaoComputador == Opcao.sair) {
    throw ArgumentError('A opção sair não participa de uma rodada.');
  }

  if (opcaoUsuario == opcaoComputador) {
    return 'Empate';
  }

  final usuarioVenceu =
      opcaoUsuario == Opcao.papel && opcaoComputador == Opcao.pedra ||
          opcaoUsuario == Opcao.pedra && opcaoComputador == Opcao.tesoura ||
          opcaoUsuario == Opcao.tesoura && opcaoComputador == Opcao.papel;

  return usuarioVenceu ? 'Você venceu' : 'Computador venceu';
}

VencedorPartida? verificaVencedorPartida({
  required int vitoriasUsuario,
  required int vitoriasComputador,
}) {
  if (vitoriasUsuario >= vitoriasNecessarias) {
    return VencedorPartida.usuario;
  }

  if (vitoriasComputador >= vitoriasNecessarias) {
    return VencedorPartida.computador;
  }

  return null;
}

int? pegaOpcaoUsuario() {
  final entrada = stdin.readLineSync();
  if (entrada == null) {
    return Opcao.sair.index + 1;
  }

  return parseOpcao(entrada);
}

void jogo({Random? gerador}) {
  final random = gerador ?? Random();
  var rodada = 1;
  var vitoriasUsuario = 0;
  var vitoriasComputador = 0;
  VencedorPartida? vencedor;

  exibe('Melhor de $maximoRodadas: vence quem ganhar 3 rodadas.\n');

  while (vencedor == null) {
    exibe('Rodada $rodada de $maximoRodadas');
    exibe('1 - Pedra\n2 - Papel\n3 - Tesoura\n4 - Sair');
    final opUsuario = pegaOpcaoUsuario();

    if (!opcaoEhValida(opUsuario)) {
      exibe('Opção inválida. Digite um número de 1 a 4.\n');
      continue;
    }

    final opcaoUsuario = mapeiaOpcao(opUsuario!);
    if (opcaoUsuario == Opcao.sair) {
      exibe('Partida encerrada antes do fim.');
      exibe('Placar: você $vitoriasUsuario x $vitoriasComputador computador');
      return;
    }

    final opcaoComputador = mapeiaOpcao(random.nextInt(3) + 1);
    exibe(
      'Você (${opcaoUsuario.name}) vs '
      '(${opcaoComputador.name}) computador',
    );
    final resultado = decideResultado(opcaoUsuario, opcaoComputador);
    exibe(resultado);

    if (resultado == 'Empate') {
      exibe('A rodada será repetida.');
    } else {
      if (resultado == 'Você venceu') {
        vitoriasUsuario++;
      } else {
        vitoriasComputador++;
      }

      exibe(
        'Placar: você $vitoriasUsuario x $vitoriasComputador computador',
      );
      rodada++;
      vencedor = verificaVencedorPartida(
        vitoriasUsuario: vitoriasUsuario,
        vitoriasComputador: vitoriasComputador,
      );
    }

    exibe('***********************************\n');
  }

  if (vencedor == VencedorPartida.usuario) {
    exibe('Você venceu a melhor de $maximoRodadas!');
  } else {
    exibe('O computador venceu a melhor de $maximoRodadas!');
  }
}
