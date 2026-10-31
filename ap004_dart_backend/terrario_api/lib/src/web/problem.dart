import 'dart:convert';

import 'package:shelf/shelf.dart';

/// Prefixo usado para identificar os tipos de problema desta API.
const String _baseTipos = 'https://api.terrarios.local/problemas';

/// Monta uma resposta de erro no formato definido pela RFC 9457.
Response problema({
  required int status,
  required String titulo,
  required String detalhe,
  String? tipo,
  Map<String, dynamic> extras = const {},
}) {
  final corpo = <String, dynamic>{
    'type': tipo == null ? 'about:blank' : '$_baseTipos/$tipo',
    'title': titulo,
    'status': status,
    'detail': detalhe,
    ...extras,
  };

  return Response(
    status,
    body: jsonEncode(corpo),
    headers: {
      // O sufixo +json diz aos clientes que o corpo é JSON, e o prefixo
      // problem diz que ele segue a estrutura padronizada de erro.
      'content-type': 'application/problem+json; charset=utf-8',
    },
  );
}
