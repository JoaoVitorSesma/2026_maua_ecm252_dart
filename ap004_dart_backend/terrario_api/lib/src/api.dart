import 'package:mysql_dart/mysql_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'config/app_config.dart';
import 'controllers/health_controller.dart';
import 'controllers/terrario_controller.dart';
import 'repositories/mysql_terrario_repository.dart';
import 'services/terrario_service.dart';
import 'web/middlewares.dart';
import 'web/problem.dart';

/// Constrói o handler completo da aplicação: rotas mais pilha de middlewares.
Handler construirApi(AppConfig config, MySQLConnectionPool pool) {
  // As dependências são criadas de fora para dentro e injetadas por
  // construtor. Trocar MySqlTerrarioRepository por uma implementação em
  // memória é uma alteração de uma linha.
  final repository = MySqlTerrarioRepository(pool);
  final service = TerrarioService(repository);
  final terrarios = TerrarioController(service);
  final health = HealthController(pool);

  final raiz = Router();

  raiz.mount('/api/v1/terrarios', terrarios.router.call);
  raiz.mount('/health', health.router.call);

  // Rota curinga: captura tudo o que não casou com as rotas acima.
  // A sintaxe <nome|expressão> do shelf_router declara um parâmetro
  // chamado "ignorado" cujo valor precisa casar com a expressão regular
  // ".*" — ou seja, qualquer coisa, inclusive barras. O nome existe só
  // porque a sintaxe exige um; o valor não é usado. E "all" significa
  // qualquer verbo HTTP.
  raiz.all('/<ignorado|.*>', (Request requisicao) {
    return problema(
      status: 404,
      tipo: 'rota-inexistente',
      titulo: 'Rota nao encontrada',
      detalhe: 'Nao existe ${requisicao.method} /${requisicao.url.path}.',
    );
  });

  // A ordem importa: o log é o mais externo para medir o tempo total,
  // e o tratamento de erros precisa envolver o roteador.
  return const Pipeline()
      .addMiddleware(registrarAcessos())
      .addMiddleware(liberarCors())
      .addMiddleware(tratarErros(detalharFalhas: !config.producao))
      .addHandler(raiz.call);
}
