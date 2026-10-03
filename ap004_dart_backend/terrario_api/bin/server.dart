import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:terrario_api/src/config/app_config.dart';

// `Future<T>` é o equivalente em Dart à Promise do JavaScript: um valor que
// ainda não chegou. `async` marca a função que devolve um Future e `await`
// pausa a execução até ele completar, exatamente como no JavaScript.
Future<void> main() async {
  // Resolve e valida toda a configuração antes de abrir qualquer porta.
  final config = AppConfig.fromEnv();

  Response handler(Request request) {
    return Response.ok('API de Terrarios no ar\n');
  }

  // InternetAddress.anyIPv4 (0.0.0.0) é obrigatório dentro de contêineres:
  // ouvir apenas em localhost tornaria o servidor inacessível de fora dele.
  final servidor = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    config.serverPort,
  );

  stdout.writeln('Servidor ouvindo em http://localhost:${servidor.port}');
  stdout.writeln(config);
}
