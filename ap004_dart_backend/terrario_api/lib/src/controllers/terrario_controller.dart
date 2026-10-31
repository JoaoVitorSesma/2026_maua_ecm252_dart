import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../core/erros.dart';
import '../models/terrario.dart';
import '../repositories/terrario_repository.dart';
import '../services/terrario_service.dart';
import '../web/links.dart';

class TerrarioController {
  TerrarioController(this._service);

  final TerrarioService _service;

  /// Serializa um mapa como JSON com o cabeçalho correto.
  Response _json(
    int status,
    Object corpo, {
    Map<String, String> cabecalhos = const {},
  }) {
    return Response(
      status,
      body: jsonEncode(corpo),
      headers: {
        'content-type': 'application/json; charset=utf-8',
        ...cabecalhos,
      },
    );
  }

  /// Converte o segmento de URL em inteiro, recusando lixo como /terrarios/abc.
  int _idValido(String bruto) {
    final id = int.tryParse(bruto);
    if (id == null || id < 1) {
      throw RequisicaoInvalida('O identificador "$bruto" nao e um numero.');
    }
    return id;
  }

/// Lê e decodifica o corpo da requisição.
Future<Map<String, dynamic>> _lerJson(Request requisicao) async {
  final tipo = requisicao.headers['content-type'] ?? '';
  if (!tipo.contains('application/json')) {
    throw RequisicaoInvalida('Envie o corpo com Content-Type application/json.');
  }

  final texto = await requisicao.readAsString();
  if (texto.trim().isEmpty) {
    throw RequisicaoInvalida('O corpo da requisicao esta vazio.');
  }

  try {
    final decodificado = jsonDecode(texto);
    if (decodificado is! Map<String, dynamic>) {
      throw RequisicaoInvalida('O corpo deve ser um objeto JSON.');
    }
    return decodificado;
  } on FormatException {
    throw RequisicaoInvalida('O corpo nao e um JSON valido.');
  }
}

  /// Converte o mapa recebido em uma entidade, acumulando problemas de
  /// tipo e de campos ausentes. Regras de faixa e de tamanho continuam
  /// no serviço; aqui trata-se apenas da forma dos dados.
  Terrario _montarTerrario(Map<String, dynamic> corpo) {
    final erros = <String, String>{};

    final apelido = corpo['apelido'];
    if (apelido is! String) erros['apelido'] = 'Campo obrigatorio do tipo texto.';

    final biomaBruto = corpo['bioma'];
    final bioma = biomaBruto is String ? Bioma.porNome(biomaBruto) : null;
    if (bioma == null) {
      erros['bioma'] =
          'Use um destes valores: ${Bioma.values.map((b) => b.name).join(', ')}.';
    }

    final umidade = corpo['umidadeAlvo'];
    if (umidade is! int) erros['umidadeAlvo'] = 'Campo obrigatorio do tipo inteiro.';

    final volume = corpo['volumeLitros'];
    if (volume is! num) erros['volumeLitros'] = 'Campo obrigatorio do tipo numerico.';

    final dataBruta = corpo['dataMontagem'];
    DateTime? data;
    if (dataBruta is String) data = DateTime.tryParse(dataBruta);
    if (data == null) erros['dataMontagem'] = 'Use o formato AAAA-MM-DD.';

    if (erros.isNotEmpty) {
      throw ErroValidacao('Os dados enviados sao invalidos.', erros);
    }

    return Terrario(
      apelido: (apelido as String).trim(),
      bioma: bioma!,
      umidadeAlvo: umidade as int,
      volumeLitros: (volume as num).toDouble(),
      dataMontagem: data!,
    );
  }

/// Cada controlador expõe seu próprio roteador, que depois é montado
/// sob um prefixo pelo roteador principal.
Router get router {
  final router = Router();

  router.get('/', _listar);
  router.get('/<id>', _buscar);
  router.post('/', _criar);
  router.put('/<id>', _atualizar);
  router.delete('/<id>', _remover);

  return router;
}

  Future<Response> _listar(Request requisicao) async {
    final q = requisicao.url.queryParameters;
    final filtro = FiltroTerrario(
    bioma: Bioma.porNome(q['bioma']),
    umidadeMinima: int.tryParse(q['umidadeMinima'] ?? ''),
    pagina: int.tryParse(q['pagina'] ?? '') ?? 1,
    tamanhoPagina: int.tryParse(q['tamanhoPagina'] ?? '') ?? 20,
  );
    final pagina = await _service.listar(filtro);

    // Preserva os filtros ativos nos links de paginação, para que
    // avançar de página não perca o critério de busca.
    final filtrosAtuais = <String, String>{
      if (q['bioma'] != null) 'bioma': q['bioma']!,
      if (q['umidadeMinima'] != null) 'umidadeMinima': q['umidadeMinima']!,
    };

    return _json(200, {
      'itens': pagina.itens
          .map((t) => {...t.toJson(), '_links': linksDoTerrario(t)})
          .toList(),
      'pagina': pagina.pagina,
      'tamanhoPagina': pagina.tamanhoPagina,
      'total': pagina.total,
      'totalPaginas': pagina.totalPaginas,
      '_links': linksDaColecao(pagina, filtrosAtuais),
    });
  }

  Future<Response> _buscar(Request requisicao, String id) async {
    final terrario = await _service.buscarPorId(_idValido(id));
    return _json(200, {
      ...terrario.toJson(),
      '_links': linksDoTerrario(terrario),
    });
  }

  Future<Response> _criar(Request requisicao) async {
    final corpo = await _lerJson(requisicao);
    final criado = await _service.criar(_montarTerrario(corpo));

    return _json(
      201,
      {...criado.toJson(), '_links': linksDoTerrario(criado)},
      cabecalhos: {'location': '/api/v1/terrarios/${criado.id}'},
    );
  }

  Future<Response> _atualizar(Request requisicao, String id) async {
    final corpo = await _lerJson(requisicao);
    final atualizado =
        await _service.atualizar(_idValido(id), _montarTerrario(corpo));
    return _json(200, atualizado.toJson());
  }

  Future<Response> _remover(Request requisicao, String id) async {
    await _service.remover(_idValido(id));
    // 204: sucesso sem corpo. Devolver um JSON dizendo "removido com
    // sucesso" seria redundante com o próprio código de status.
    return Response(204);
  }
}
}
