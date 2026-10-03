# Aula 04 — Back End com Dart

## 1. Introdução

Projeto da apostila: uma API REST para um catálogo de terrários, usando Dart,
shelf, MySQL e Docker. O cliente acessará a API, que consultará o banco em uma
rede privada do Docker.

Cada terrário terá apelido, bioma, umidade-alvo, volume em litros e data de
montagem, além do identificador e das datas de criação e atualização.

O capítulo 1 é conceitual e não contém comandos ou arquivos de código a criar.
O projeto será desenvolvido em `terrario_api/`, na ordem da apostila.

## 2. Preparando o ambiente

Comandos executados:

```text
dart --version
docker --version
docker compose version
dart create -t console terrario_api
cd terrario_api
dart pub add shelf shelf_router dotenv mysql_dart
dart pub add dev:test dev:lints
dart analyze
dart format .
```

Ambiente verificado: Dart 3.13.1 no Windows, Docker 29.5.2 e Docker Compose
v5.1.3. As dependências foram instaladas pelos comandos da apostila, com as
versões compatíveis resolvidas pelo pub registradas no `pubspec.lock`.

O `pubspec.yaml` recebeu a descrição, `publish_to: none` e o requisito de SDK
do código 2.1. O `analysis_options.yaml` recebeu as regras do código 2.3.
A estrutura do item 2.4 será construída arquivo por arquivo nos capítulos
seguintes, conforme indicado no texto.

O ambiente bloqueou a criação dos subprocessos Dart; os comandos afetados
foram repetidos com a permissão necessária. Como `dart create` já havia gerado
os arquivos, sua etapa interrompida de dependências foi concluída com
`dart pub get`.

O exemplo gerado por `dart create` usava `print`, incompatível com a regra
`avoid_print` do código 2.3. Essa chamada foi substituída por `log` de
`dart:developer`, mantendo o exemplo até sua substituição pela apostila.

Verificação final: `dart analyze` retornou `No issues found!`, e
`dart format .` terminou sem alterações pendentes de formatação.

## 3. Configuração por variáveis de ambiente

Criados `.env`, `.env.example`, `lib/src/config/env.dart` e
`lib/src/config/app_config.dart`, conforme os códigos 3.1 a 3.5.
O ponto de entrada gerado foi substituído por `bin/server.dart`, com o teste
provisório do código 3.6.

O `.gitignore` foi atualizado conforme o código 3.3. O `pubspec.lock`,
versionado no capítulo 2, foi retirado do controle de versão e mantido
localmente para seguir essa orientação. O `.env` permanece apenas local.

Executado `dart run bin/server.dart`:

```text
AppConfig(appEnv: development, serverPort: 8080, db: terrario_app@127.0.0.1:3307/terrarios, pool: 10)
Porta lida: 8080
```

Ao comentar `DB_HOST` no `.env`, a execução falhou como previsto:

```text
Unhandled exception:
Bad state: Variável de ambiente obrigatória ausente: DB_HOST
```

A linha foi restaurada e o comando voltou a produzir a configuração e a
porta esperadas. `dart format .` e `dart analyze` concluídos antes do commit,
com `No issues found!`.

## 4. O primeiro servidor HTTP

O teste provisório de `bin/server.dart` foi substituído pelo código 4.1.
O servidor resolve a configuração antes de abrir a porta e escuta em
`InternetAddress.anyIPv4`, conforme a apostila.

Executado `dart run bin/server.dart`:

```text
Servidor ouvindo em http://localhost:8080
AppConfig(appEnv: development, serverPort: 8080, db: terrario_app@127.0.0.1:3307/terrarios, pool: 10)
```

Em outro terminal, executado `curl.exe -i http://localhost:8080/qualquer/coisa`.
No PowerShell, `curl.exe` chama diretamente o curl usado pela apostila.
A resposta incluiu:

```text
HTTP/1.1 200 OK
content-length: 23
x-frame-options: SAMEORIGIN
x-content-type-options: nosniff

API de Terrarios no ar
```

A apostila mostra `content-length: 24`, mas o corpo do código 4.1,
`API de Terrarios no ar\n`, tem 23 bytes. O código foi mantido conforme o
bloco, e o servidor retornou o tamanho correto. O cabeçalho `date` corresponde
ao momento da requisição.

O servidor foi encerrado com Ctrl+C após a conferência. Para repetir a
verificação, execute os mesmos comandos acima na pasta `terrario_api`.
`dart format .` e `dart analyze` concluídos antes do commit, com
`No issues found!`.

## 5. O modelo de maturidade de Richardson

Capítulo conceitual concluído: nível 0 (HTTP como túnel), nível 1 (recursos),
nível 2 (verbos e códigos de status) e nível 3 (HATEOAS), incluindo os formatos
HAL, JSON:API e Siren.

Os códigos 5.1 a 5.13 ilustram requisições, respostas e representações; não
instruem a criar arquivos ou implementar rotas nesta etapa. O servidor do
capítulo 4 foi mantido, conforme a sequência da apostila.

`dart format .` e `dart analyze` concluídos antes do commit, com
`No issues found!`.

## 6. Arquitetura em camadas

Criado `lib/src/models/terrario.dart` com o enum `Bioma` e a entidade imutável
`Terrario`, conforme o código 6.1. Os métodos `copyWith`, `toJson` e
`_somenteData` do código 6.2 foram acrescentados no mesmo arquivo, sem duplicar
as linhas de contexto. O modelo não importa HTTP ou SQL, conforme a
verificação indicada na apostila.

Criado `lib/src/core/erros.dart`, conforme o código 6.3, com a classe base
`sealed` `ErroApp` e as exceções `NaoEncontrado`, `ErroValidacao`, `Conflito`
e `RequisicaoInvalida`.

O capítulo não pede novos comandos de execução ou respostas HTTP.
`dart format .` terminou sem alterações e `dart analyze` retornou
`No issues found!` antes do commit.

## 7. Contêineres e Docker

Capítulo conceitual concluído: servidores físicos, máquinas virtuais e
contêineres; namespaces, cgroups e sistema de arquivos em camadas; imagem,
contêiner, registro, volume, rede, publicação de portas e orquestração.

O capítulo não instrui a criar arquivos ou executar comandos. A criação
do banco em contêiner começa no capítulo 8.

`dart format .` e `dart analyze` concluídos antes do commit, com
`No issues found!`.

## 8. O banco MySQL em um contêiner

Criada a pasta `docker/mysql/init/` e o arquivo `01-schema.sql`, conforme o
código 8.1, antes da primeira inicialização do banco. O script cria a tabela
com os índices e restrições indicados e insere os quatro terrários da apostila.

O Docker Desktop estava parado e foi iniciado para executar esta etapa.
O contêiner foi criado pelo comando do item 8.3, adaptando apenas a sintaxe
do caminho de montagem para o PowerShell no Windows:

```powershell
docker run --name mysql-terrarios -e MYSQL_ROOT_PASSWORD=root-dev-2026 -e MYSQL_DATABASE=terrarios -e MYSQL_USER=terrario_app -e MYSQL_PASSWORD=terrario-dev-2026 -v "C:/Users/jv070/Documents/ecm252/dart/ap004_dart_backend/terrario_api/docker/mysql/init:/docker-entrypoint-initdb.d:ro" -p 3307:3306 -d mysql:8.4
docker logs -f mysql-terrarios
```

As credenciais utilizadas são as de exemplo da apostila e coincidem com o
`.env` local. A imagem `mysql:8.4` baixada executa MySQL 8.4.11.
Os logs confirmaram `Initializing database files`, a execução de
`/docker-entrypoint-initdb.d/01-schema.sql` e `ready for connections` na
porta 3306. O acompanhamento dos logs foi encerrado com Ctrl+C.

Executada a conferência do item 8.4 pelo cliente interativo:

```text
docker exec -it mysql-terrarios mysql -u terrario_app -p terrarios
mysql> SELECT id, apelido, bioma, umidade_alvo FROM terrarios;
+----+---------------------+-----------+--------------+
| id | apelido             | bioma     | umidade_alvo |
+----+---------------------+-----------+--------------+
|  1 | Vale das Samambaias | tropical  |           85 |
|  2 | Duna de Bolso       | desertico |           20 |
|  3 | Bosque de Musgo     | musgo     |           92 |
|  4 | Clareira Fria       | temperado |           60 |
+----+---------------------+-----------+--------------+
4 rows in set (0.01 sec)
mysql> exit
```

O cliente foi encerrado e o contêiner `mysql-terrarios` permanece rodando,
com a porta local 3307 publicada, conforme a orientação da apostila.
`dart format .` terminou sem alterações e `dart analyze` retornou
`No issues found!` antes do commit.

Execução concluída até o item 8.4, na página 32 da apostila. O capítulo 9
não foi iniciado.
