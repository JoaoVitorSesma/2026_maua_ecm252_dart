import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:terrario_api/src/api.dart';
import 'package:terrario_api/src/config/app_config.dart';
import 'package:terrario_api/src/config/database.dart';

Future<void> main() async {
  final config = AppConfig.fromEnv();
  stdout.writeln('Iniciando com $config');

  final pool = criarPool(config);

  // O contêiner do banco pode demorar dezenas de segundos na primeira
  // subida, enquanto executa os scripts de inicialização.
  stdout.writeln('Aguardando o banco de dados...');
  await aguardarBanco(pool);
  stdout.writeln('Banco disponivel.');

  final servidor = await shelf_io.serve(
    construirApi(config, pool),
    InternetAddress.anyIPv4,
    config.serverPort,
  );

  stdout.writeln('Servidor ouvindo em http://localhost:${servidor.port}');

  // Desligamento gracioso: ao receber SIGTERM (enviado por
  // "docker stop" e pelo Kubernetes) ou SIGINT (Ctrl+C), o servidor
  // para de aceitar novas conexões, conclui as que estão em andamento
  // e só então fecha o pool. Sem isso, requisições em voo são
  // interrompidas no meio e transações podem ficar penduradas.
  Future<void> desligar(ProcessSignal sinal) async {
    stdout.writeln('Recebido $sinal, encerrando...');
    await servidor.close();
    await pool.close();
    exit(0);
  }

  ProcessSignal.sigint.watch().listen(desligar);
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen(desligar);
  }
}
