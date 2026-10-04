# ECM252 — Dart

Exemplos, exercícios e projetos em Dart da disciplina ECM252 do Instituto Mauá de Tecnologia, em 2026.

## Aulas

| Pasta | Conteúdo |
| --- | --- |
| [ap001_dart_introducao](ap001_dart_introducao/) | Introdução à linguagem, exemplos da apostila e exercícios. |
| [ap002_dart_sound_null_safety](ap002_dart_sound_null_safety/) | Laços, entrada e saída, null safety e jogo pedra–papel–tesoura. |
| [ap004_dart_backend](ap004_dart_backend/) | API de catálogo de terrários com Dart, shelf e MySQL. |

Cada aula mantém sua própria estrutura. Execute os comandos dentro da pasta indicada; não existe um pacote único na raiz deste repositório.

## Executar

Instale o SDK Dart compatível com o `pubspec.yaml` da aula. Para os exemplos da introdução:

```powershell
cd ap001_dart_introducao
dart run apostila/01_hello_world.dart
```

Para o jogo, a partir da raiz do repositório:

```powershell
cd ap002_dart_sound_null_safety/pedra_papel_tesoura
dart pub get
dart run
```

Para a API, a partir da raiz:

```powershell
cd ap004_dart_backend/terrario_api
dart pub get
Copy-Item .env.example .env
```

Ajuste o `.env` local e prepare o MySQL conforme o [registro da aula 04](ap004_dart_backend/README.md). Em seguida, execute `dart run bin/server.dart`. Os caminhos absolutos registrados nessa aula correspondem ao ambiente original; adapte a montagem do diretório `docker/mysql/init` à localização deste clone.

Consulte o README de cada aula para seus comandos de verificação e o ponto alcançado na apostila. Dependências e arquivos locais de ambiente precisam ser preparados em cada clone; os arquivos `.env` não são publicados.

## Origem e histórico

Este projeto foi separado da pasta `dart` da `main` de [2026_maua_ecm252](https://github.com/JoaoVitorSesma/2026_maua_ecm252), incluindo o caminho antigo da primeira aula. Autores, datas e mensagens foram preservados; os identificadores dos commits mudaram com a extração. As branches auxiliares e as tags continuam no repositório original.

O desenvolvimento de Dart passa a ocorrer neste repositório. As pastas do repositório original permanecem como referência e não são sincronizadas automaticamente.

Projetos relacionados: [Flutter](https://github.com/JoaoVitorSesma/2026_maua_ecm252_flutter) e [React](https://github.com/JoaoVitorSesma/2026_maua_ecm252_react).
