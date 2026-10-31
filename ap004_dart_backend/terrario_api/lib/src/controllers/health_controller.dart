import 'dart:convert';

import 'package:mysql_dart/mysql_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class HealthController {
  HealthController(this._pool);

  final MySQLConnectionPool _pool;

  Router get router {
    final router = Router();

    // Liveness: o processo está de pé? Não toca no banco de propósito,
    // para que uma indisponibilidade do MySQL não faça o orquestrador
    // matar um processo que está perfeitamente saudável.
    router.get('/live', (Request _) => _json(200, {'status': 'ok'}));

    // Readiness: o serviço consegue atender de verdade? Aqui sim o banco
    // é consultado, porque sem ele a API não tem o que responder.
    router.get('/ready', (Request _) async {
      try {
        await _pool.execute('SELECT 1');
        return _json(200, {'status': 'ok', 'banco': 'ok'});
      } catch (_) {
        return _json(503, {'status': 'degradado', 'banco': 'indisponivel'});
      }
    });

    return router;
  }

  Response _json(int status, Map<String, dynamic> corpo) => Response(
    status,
    body: jsonEncode(corpo),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}
