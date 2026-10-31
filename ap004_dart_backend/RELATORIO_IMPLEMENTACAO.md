# Implementação da apostila de Back End com Dart

Verificação realizada em 31/10/2026, no repositório independente de Dart,
na branch `feat/concluir-apostila-backend`. As pastas do repositório original
`ecm252/dart/` não foram alteradas.

O pedido foi implementar o material na ordem e registrar eventuais erros ao
final. Por isso, o projeto principal contém a transcrição dos exemplos, com
os acréscimos aplicados nos pontos indicados pelo texto. Comentários que apenas
representavam código já apresentado não foram copiados como implementação.
O limite de paginação é 100, conforme o código 10.1.

## Partes implementadas

As páginas abaixo são as numeradas na apostila; a posição no leitor de PDF
é quatro páginas à frente.

| Capítulo | Páginas | Implementação |
| --- | --- | --- |
| 9 — Persistência | 32–40 | Já estava implementado antes desta continuação. |
| 10 — Serviço | 40–45 | `TerrarioService`, validações e dois testes; experiência de falha executada e desfeita. |
| 11 — Web | 45–61 | Problem JSON, middlewares, CRUD HTTP, saúde, montagem da API e servidor. |
| 12 — HATEOAS | 62–65 | Links dos recursos e da coleção, com preservação dos filtros. |
| 13 — Documentação | 65–71 | Contrato de listagem, Swagger UI e controlador de documentação. |
| 14 — Imagem | 71–74 | `Dockerfile` com compilação AOT e imagem final `scratch`; `.dockerignore`. |
| 15 — Compose | 74–80 | Banco, API, rede, volume, healthcheck e script Bash de inicialização. |
| 16 — Boas práticas | 81–82 | Dois testes adicionais, totalizando os quatro casos da apostila. |
| 17 — Exercícios | 83 | Resolução dos dez exercícios em `exercicios/capitulo17.patch`, separada dos exemplos. |

## Erros encontrados

### 1. Chave excedente no controlador: impede compilar

Local: `terrario_api/lib/src/controllers/terrario_controller.dart:181`.
Origem: código 11.10, página numerada 57, posição 61 no PDF.

O bloco termina com duas chaves depois do fechamento de `_remover`, mas
apenas uma é necessária para fechar a classe. Ao encaixar os métodos conforme
o texto, a última chave fica fora da classe. Ela foi mantida na transcrição.

Reprodução: `dart analyze` acusa `expected_executable`; `dart compile exe
bin/server.dart` acusa `Expected a declaration, but got '}'`.

Correção proposta: remover a última chave excedente. O patch de correções
também formata o controlador e coloca chaves em três condicionais longas
para atender ao lint depois da formatação.

### 2. Variável sem uso no repositório: aviso do analisador

Local: `terrario_api/lib/src/repositories/mysql_terrario_repository.dart:131`.
Origem: código 9.6, página numerada 38, posição 42 no PDF.

Em `atualizar`, o resultado do `UPDATE` é atribuído a `resultado`, mas o método
retorna a releitura do registro e não utiliza essa variável. O aviso é
`unused_local_variable`; não é o erro que impede a compilação.

Correção proposta: substituir `final resultado = await _pool.execute(...)`
por `await _pool.execute(...)` somente nesse método.

### 3. Datas inexistentes são normalizadas, em vez de recusadas

Local: `terrario_api/lib/src/controllers/terrario_controller.dart:89`.

`DateTime.tryParse` não verifica estritamente o formato de uma data civil.
Foi reproduzido, numa cópia com a correção sintática, um POST com
`dataMontagem: "2026-02-31"`: a resposta foi 201 e a data persistida pelo
repositório em memória foi `2026-03-03`.

Correção a decidir: exigir `AAAA-MM-DD`, construir a data e conferir se
ano, mês e dia resultantes são exatamente os informados. Essa alteração
de comportamento não foi aplicada à transcrição nem ao patch mínimo.

### 4. Links condicionais não impõem a mesma regra no serviço

Local: `terrario_api/lib/src/web/links.dart:26` e métodos de alteração e
remoção em `terrario_api/lib/src/services/terrario_service.dart`.

Os links `edit` e `delete` desaparecem para terrários com mais de 365 dias,
mas os métodos do serviço continuam permitindo essas operações. Foi
reproduzido um terrário de `2020-01-01` sem link `edit` cujo PUT retornou 200.

Correção a decidir com o professor: se a idade deve impedir alterações,
aplicar a regra também no serviço; caso contrário, manter os links de
alteração e remoção disponíveis. O exemplo foi preservado.

## Documentação propositalmente parcial

Os códigos 13.1 e 13.2 descrevem apenas GET `/terrarios`. O próprio texto
explica essa redução e propõe estender o contrato às outras operações.
Isso não é um erro de transcrição. O contrato completo está incluído na
resolução separada dos exercícios.

## Correções preparadas, sem aplicação ao projeto principal

`CORRECOES_APOSTILA.patch` contém as correções 1 e 2, mais a formatação do
controlador e os ajustes de lint mencionados. A aplicação foi testada em
uma cópia isolada. Nela, `dart analyze` não encontrou problemas, os cinco
testes passaram e `dart compile exe bin/server.dart` gerou o executável.

Para conferir e aplicar, a partir da raiz do repositório Dart:

```powershell
git apply --check ap004_dart_backend/CORRECOES_APOSTILA.patch
git apply ap004_dart_backend/CORRECOES_APOSTILA.patch
cd ap004_dart_backend/terrario_api
dart format .
dart analyze
dart test
```

Os itens 3 e 4 precisam de alterações de comportamento e permanecem
registrados para a próxima correção, inclusive na versão dos exercícios.

## Verificações realizadas

| Verificação | Resultado |
| --- | --- |
| Testes da transcrição principal | Cinco passaram: quatro da apostila e o teste inicial `calculate`. |
| Experiência do item 10.1.1 | Falha esperada observada com limite 1000; limite 100 restaurado. |
| Análise e compilação da transcrição | Bloqueadas pela chave excedente; análise também aponta a variável sem uso. |
| Cópia com o patch mínimo | Análise sem problemas, cinco testes passando e executável gerado. |
| Versão dos exercícios | Análise sem problemas, 13 testes passando e executável gerado. |
| HTTP dos exercícios | Servidor local real e repositório em memória: CRUD, PATCH, links, filtros, documentação, correlação e limite de taxa. |
| Erro MySQL 1062 | Exceção do driver simulada na fronteira do pool; tradução em conflito e HTTP 409 verificada. |
| YAML e referências OpenAPI | Arquivos legíveis e referências locais válidas nas duas versões. |
| Docker Compose | `docker compose --env-file .env.example config --quiet` passou. |
| Script de inicialização | `bash -n scripts/up.sh` passou no Git Bash. |
| Patches | Aplicados em sequência numa cópia limpa; os 36 arquivos finais coincidiram com a versão verificada dos exercícios. |

Os testes unitários originais não importam o controlador. Por isso podem
passar mesmo quando a aplicação web não compila. A revisão local também
conferiu a montagem dos blocos, os contratos e os dois comportamentos
problemáticos reproduzidos acima, em sequência conforme as instruções do projeto.

## Limites da verificação

O Docker Desktop estava desligado. Não foram executados o build Linux da
imagem, a inicialização completa do Compose, a migração SQL ou consultas ao
MySQL real nesta continuação. O executável verificado é Windows; isso não
substitui o build da imagem Linux. A interface Swagger foi servida por HTTP,
mas o carregamento dos arquivos externos da CDN não foi verificado em navegador.

Não foram alteradas credenciais, criados arquivos `.env` nem removidos volumes.
A implementação inicial partiu do estado local previamente verificado do
capítulo 9, porque o fetch não tinha acesso à rede. Na etapa de versionamento,
o fetch de `origin/main` foi realizado e o trabalho foi organizado em commits
por capítulo, de 10 a 17, no histórico desta branch.
