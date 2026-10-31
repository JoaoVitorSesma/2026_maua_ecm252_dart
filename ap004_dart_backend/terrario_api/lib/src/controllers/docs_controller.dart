import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Serve a documentação interativa da API.
///
/// São duas rotas, e as duas fazem a mesma coisa: ler um arquivo do disco e
/// devolvê-lo com o tipo de mídia adequado. Manter o HTML em um arquivo .html
/// — e não em uma String dentro desta classe — preserva o realce de sintaxe
/// no editor e evita misturar duas linguagens no mesmo arquivo.
class DocsController {
  DocsController({
    this.caminhoSpec = 'openapi.yaml',
    this.caminhoPagina = 'web/docs/index.html',
  });

  final String caminhoSpec;
  final String caminhoPagina;

  /// Lê um arquivo e o devolve, ou responde 404 quando ele não existe.
  Future<Response> _servirArquivo(String caminho, String tipoMidia) async {
    final arquivo = File(caminho);
    if (!await arquivo.exists()) {
      return Response.notFound('Arquivo nao encontrado: $caminho');
    }
    return Response.ok(
      await arquivo.readAsString(),
      headers: {'content-type': tipoMidia},
    );
  }

  Router get router {
    final router = Router();

    router.get(
      '/openapi.yaml',
      (Request _) =>
          _servirArquivo(caminhoSpec, 'application/yaml; charset=utf-8'),
    );

    router.get(
      '/',
      (Request _) => _servirArquivo(caminhoPagina, 'text/html; charset=utf-8'),
    );

    return router;
  }
}
