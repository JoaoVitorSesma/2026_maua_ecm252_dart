import 'dart:io';

import 'package:terrario_api/src/config/app_config.dart';
import 'package:terrario_api/src/config/database.dart';
import 'package:terrario_api/src/repositories/mysql_terrario_repository.dart';
import 'package:terrario_api/src/repositories/terrario_repository.dart';

Future<void> main() async {
  final config = AppConfig.fromEnv();
  final pool = criarPool(config);
  await aguardarBanco(pool);

  final repository = MySqlTerrarioRepository(pool);

  final pagina = await repository.listar(const FiltroTerrario());
  stdout.writeln('Total no banco: ${pagina.total}');
  for (final t in pagina.itens) {
    stdout.writeln(
      '  ${t.id} - ${t.apelido} '
      '(${t.bioma.name}, ${t.umidadeAlvo}%)',
    );
  }

  // Fecha o pool para que o processo consiga terminar.
  await pool.close();
}
