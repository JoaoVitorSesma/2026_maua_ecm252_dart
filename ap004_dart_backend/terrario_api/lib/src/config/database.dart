import 'package:mysql_dart/mysql_dart.dart';
import 'app_config.dart';

// Cria o pool de conexões a partir da configuração da aplicação.
//
// O pool é criado uma única vez, no boot, e compartilhado por todas as
// requisições. Ele não abre conexões imediatamente: cada conexão nasce
// na primeira vez que é necessária e depois é reaproveitada.

MySQLConnectionPool criarPool (AppConfig config){
  return MySQLConnectionPool(
    host: config.dbHost,
    port: config.dbPort,
    userName: config.dbUser,
    password: config.dbPassword,
    databaseName: config.dbName,
    maxConnections: config.dbPoolSize, // Número máximo de conexões no pool
    // Dentro da rede privada do Docker o tráfego não sai da máquina, então
    // TLS é dispensável. Em produção, com o banco em outro host, troque
    // para secure: true e remova allowPublicKeyRetrieval.
    secure: false,
    // Necessário porque o MySQL 8 autentica com caching_sha2_password e,
    // sem TLS, o cliente precisa buscar a chave pública do servidor.
    allowPublicKeyRetrieval: true,
  );
}