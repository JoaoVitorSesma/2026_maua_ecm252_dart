import 'package:dotenv/dotenv.dart';

/// Ponto único de leitura de variáveis de ambiente.
///
/// A instância de [DotEnv] é criada uma única vez, de forma preguiçosa, na
/// primeira leitura. Quando o arquivo `.env` não existe — situação normal
/// dentro de um contêiner — o pacote simplesmente não carrega nada e as
/// variáveis reais do processo continuam disponíveis.
class Env {
  Env._();

  static final DotEnv _env = DotEnv(includePlatformEnvironment: true)..load();

  /// Lê uma variável obrigatória. Lança [StateError] se ela estiver ausente
  /// ou vazia, interrompendo a inicialização em vez de deixar o servidor
  /// subir com configuração incompleta.
  static String obrigatoria(String chave) {
    final valor = _env[chave];
    if (valor == null || valor.trim().isEmpty) {
      throw StateError('Variável de ambiente obrigatória ausente: $chave');
    }
    return valor.trim();
  }

  /// Lê uma variável opcional, devolvendo [padrao] quando ela não existe.
  static String opcional(String chave, String padrao) {
    final valor = _env[chave];
    return (valor == null || valor.trim().isEmpty) ? padrao : valor.trim();
  }

  /// Lê um inteiro, recusando valores que não sejam numéricos.
  static int inteiro(String chave, int padrao) {
    final bruto = _env[chave];
    if (bruto == null || bruto.trim().isEmpty) return padrao;
    final valor = int.tryParse(bruto.trim());
    if (valor == null) {
      throw StateError(
        'A variável $chave deve ser um número inteiro: "$bruto"',
      );
    }
    return valor;
  }
}
