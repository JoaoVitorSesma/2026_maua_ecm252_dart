import 'dart:io';

import 'package:shelf/shelf.dart';

import '../core/erros.dart';
import 'problem.dart';

/// Registra método, caminho, status e duração de cada requisição.
///
/// Uma linha por requisição, em formato estável, é o mínimo necessário para
/// diagnosticar problemas em produção. Ferramentas de agregação de logs
/// conseguem extrair métricas a partir daí.
Middleware registrarAcessos() {
  return (Handler proximo) {
    return (Request requisicao) async {
      final inicio = DateTime.now();
      final resposta = await proximo(requisicao);
      final duracao = DateTime.now().difference(inicio).inMilliseconds;

      stdout.writeln(
        '${requisicao.method} /${requisicao.url.path} '
        '-> ${resposta.statusCode} (${duracao}ms)',
      );
      return resposta;
    };
  };
}

/// Libera o consumo da API a partir de páginas hospedadas em outra origem.
Middleware liberarCors({String origem = '*'}) {
  final cabecalhos = {
    'access-control-allow-origin': origem,
    'access-control-allow-methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'access-control-allow-headers': 'Content-Type, Authorization',
    'access-control-max-age': '86400',
  };

  return (Handler proximo) {
    return (Request requisicao) async {
      // A requisição de sondagem (preflight) enviada pelo navegador antes
      // de um PUT ou DELETE deve ser respondida sem chegar ao roteador.
      if (requisicao.method == 'OPTIONS') {
        return Response(204, headers: cabecalhos);
      }
      final resposta = await proximo(requisicao);
      return resposta.change(headers: cabecalhos);
    };
  };
}

/// Converte exceções em respostas HTTP.
///
/// [detalharFalhas] deve ser falso em produção: mensagens internas podem
/// revelar nomes de tabelas, caminhos de arquivo e versões de bibliotecas.
Middleware tratarErros({required bool detalharFalhas}) {
  return (Handler proximo) {
    return (Request requisicao) async {
      try {
        return await proximo(requisicao);
      } on ErroApp catch (erro) {
        return _traduzir(erro);
      } catch (erro, pilha) {
        // Falha não prevista: registra tudo internamente e devolve pouco.
        stderr.writeln('Erro nao tratado: $erro\n$pilha');
        return problema(
          status: 500,
          tipo: 'falha-interna',
          titulo: 'Erro interno',
          detalhe: detalharFalhas
              ? erro.toString()
              : 'Ocorreu uma falha inesperada. Tente novamente mais tarde.',
        );
      }
    };
  };
}

/// O switch é exaustivo: acrescentar um novo tipo de ErroApp sem tratá-lo
/// aqui provoca erro de compilação.
Response _traduzir(ErroApp erro) {
  return switch (erro) {
    NaoEncontrado() => problema(
      status: 404,
      tipo: 'nao-encontrado',
      titulo: 'Recurso nao encontrado',
      detalhe: erro.mensagem,
    ),
    ErroValidacao() => problema(
      status: 422,
      tipo: 'validacao',
      titulo: 'Dados invalidos',
      detalhe: erro.mensagem,
      extras: {'errors': erro.campos},
    ),
    Conflito() => problema(
      status: 409,
      tipo: 'conflito',
      titulo: 'Conflito com o estado atual',
      detalhe: erro.mensagem,
    ),
    RequisicaoInvalida() => problema(
      status: 400,
      tipo: 'requisicao-invalida',
      titulo: 'Requisicao malformada',
      detalhe: erro.mensagem,
    ),
  };
}
