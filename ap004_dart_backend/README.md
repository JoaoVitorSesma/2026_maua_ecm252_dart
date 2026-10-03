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

Execução encerrada ao final do capítulo 2, aguardando aprovação para 3 e 4.
