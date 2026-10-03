import 'dart:io';

import 'package:terrario_api/src/config/app_config.dart';

void main() {
  final config = AppConfig.fromEnv();
  // stdout.writeln em vez de print: a regra avoid_print, ativada no
  // analysis_options.yaml, existe justamente para lembrar que servidores
  // devem escrever em saídas controladas.
  stdout.writeln(config);
  stdout.writeln('Porta lida: ${config.serverPort}');
}
