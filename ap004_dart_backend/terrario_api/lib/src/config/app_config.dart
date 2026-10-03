import 'env.dart';

/// Configuração da aplicação, resolvida uma única vez durante o boot.
class AppConfig {
  const AppConfig({
    required this.appEnv,
    required this.serverPort,
    required this.logLevel,
    required this.dbHost,
    required this.dbPort,
    required this.dbName,
    required this.dbUser,
    required this.dbPassword,
    required this.dbPoolSize,
  });

  final String appEnv;
  final int serverPort;
  final String logLevel;

  final String dbHost;
  final int dbPort;
  final String dbName;
  final String dbUser;
  final String dbPassword;
  final int dbPoolSize;

  /// Verdadeiro quando a aplicação roda em produção; usado para decidir
  /// o nível de detalhe das mensagens de erro devolvidas ao cliente.
  bool get producao => appEnv == 'production';

  /// Constrói a configuração a partir do ambiente e valida os limites.
  ///
  /// `factory` é um construtor que não é obrigado a criar uma instância nova:
  /// ele executa código antes de devolver o objeto e pode retornar um valor
  /// de cache, uma subclasse ou, como aqui, lançar exceção se algo estiver
  /// errado. Um construtor comum não permite nada disso, porque seu corpo só
  /// roda depois que o objeto já existe.
  factory AppConfig.fromEnv() {
    final config = AppConfig(
      appEnv: Env.opcional('APP_ENV', 'development'),
      serverPort: Env.inteiro('SERVER_PORT', 8080),
      logLevel: Env.opcional('LOG_LEVEL', 'info'),
      dbHost: Env.obrigatoria('DB_HOST'),
      dbPort: Env.inteiro('DB_PORT', 3306),
      dbName: Env.obrigatoria('DB_NAME'),
      dbUser: Env.obrigatoria('DB_USER'),
      dbPassword: Env.obrigatoria('DB_PASSWORD'),
      dbPoolSize: Env.inteiro('DB_POOL_SIZE', 10),
    );

    if (config.serverPort < 1 || config.serverPort > 65535) {
      throw StateError(
        'SERVER_PORT fora da faixa válida: ${config.serverPort}',
      );
    }
    if (config.dbPoolSize < 1) {
      throw StateError('DB_POOL_SIZE deve ser pelo menos 1.');
    }
    return config;
  }

  /// Representação segura para log: a senha nunca é impressa.
  @override
  String toString() =>
      'AppConfig(appEnv: $appEnv, serverPort: $serverPort, '
      'db: $dbUser@$dbHost:$dbPort/$dbName, pool: $dbPoolSize)';
}
